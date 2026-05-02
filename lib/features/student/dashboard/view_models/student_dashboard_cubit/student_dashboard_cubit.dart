import 'dart:developer' show log;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'student_dashboard_state.dart';

class StudentDashboardCubit extends Cubit<StudentDashboardState> {
  StudentDashboardCubit() : super(StudentDashboardInitial());

  final SupabaseClient supabase = Supabase.instance.client;

  RealtimeChannel? _subscriptionsChannel;
  RealtimeChannel? _bookingsChannel;

  // Cached student name to avoid re-fetching on every realtime update
  String _cachedStudentName = 'Student';

  Future<void> fetchDashboardData() async {
    emit(StudentDashboardLoading());
    await _loadData();
    _listenToRealtime();
  }

  Future<void> _loadData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(StudentDashboardError('Not logged in'));
        return;
      }

      final userId = user.id;

      // 1. Subscription
      final subRes = await supabase
          .from('subscriptions')
          .select()
          .eq('student_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      Map<String, dynamic> subscription = {
        'type': 'Not specified',
        'end_date': 'Not specified',
        'is_active': false,
      };
      bool hasActiveSub = false;

      if (subRes != null) {
        subscription = {
          'type': subRes['type']?.toString() ?? 'Semester',
          'end_date': (subRes['end_date'] as String?)?.split('T')[0] ?? 'Not specified',
          'is_active': subRes['is_active'] == true,
        };
        hasActiveSub = subscription['is_active'] == true;
      }

      // 2. Student name (cached to avoid redundant calls on realtime updates)
      if (_cachedStudentName == 'Student') {
        final profile = await supabase
            .from('profiles')
            .select('full_name')
            .eq('id', userId)
            .maybeSingle();

        if (profile != null && profile['full_name'] != null) {
          _cachedStudentName = profile['full_name'] as String;
        }
      }

      // 3. Active / latest booking
      Map<String, dynamic> activeBooking = {
        'bus': 'No active booking',
        'pickup': '—',
        'driver': '—',
        'time': '—',
        'status': 'None',
        'seat': null,
      };

      try {
        final bookingRes = await supabase
            .from('bookings')
            .select('''
              *,
              drivers (
                bus_number,
                profiles (
                  full_name
                ),
                pickup_points (
                  name,
                  address,
                  latitude,
                  longitude
                )
              )
            ''')
            .eq('student_id', userId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        if (bookingRes != null) {
          final driverData = bookingRes['drivers'];
          final driverProfile = driverData?['profiles'];
          final pickupPoint = driverData?['pickup_points'];

          activeBooking = {
            'bus': driverData?['bus_number']?.toString() ?? '—',
            'pickup': pickupPoint?['name']?.toString() ??
                pickupPoint?['address']?.toString() ??
                '—',
            'pickup_lat': (pickupPoint?['latitude'] as num?)?.toDouble(),
            'pickup_lng': (pickupPoint?['longitude'] as num?)?.toDouble(),
            'driver': driverProfile?['full_name']?.toString() ?? 'Unknown',
            'time': bookingRes['booking_date']?.toString() ?? '—',
            'status': (bookingRes['status'] as String? ?? 'booked').toUpperCase(),
            'seat': bookingRes['seat_number'],
            'distance': null,
          };
        }
      } catch (e) {
        log('Error fetching latest booking: $e');
      }

      // 4. Fetch Nearest Pickup Point Distances for the 3 main lines
      final List<String> lineNames = ['Mokattam', 'Nasr City', '6 October'];
      final Map<String, double> lineDistances = {};
      
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        ).timeout(const Duration(seconds: 2), onTimeout: () => throw Exception('Timeout'));

        // Calculate distance to active booking if it exists
        if (activeBooking['pickup_lat'] != null) {
          final d = Geolocator.distanceBetween(
            position.latitude, position.longitude,
            activeBooking['pickup_lat'], activeBooking['pickup_lng']
          );
          activeBooking['distance'] = d / 1000;
        }

        // Calculate distances for all lines
        final pointsRes = await supabase
            .from('pickup_points')
            .select('line_name, latitude, longitude')
            .inFilter('line_name', lineNames);

        if (pointsRes != null) {
          final points = pointsRes as List;
          for (var line in lineNames) {
            double minDistance = double.infinity;
            final linePoints = points.where((p) => p['line_name'] == line);
            for (var p in linePoints) {
               final d = Geolocator.distanceBetween(
                 position.latitude, position.longitude,
                 (p['latitude'] as num).toDouble(), (p['longitude'] as num).toDouble()
               );
               if (d < minDistance) minDistance = d;
            }
            if (minDistance != double.infinity) {
              lineDistances[line] = minDistance / 1000;
            }
          }
        }
      } catch (e) {
        log('Location/Distance calculation skipped or failed: $e');
      }

      if (!isClosed) {
        emit(StudentDashboardLoaded(
          studentName: _cachedStudentName,
          subscription: subscription,
          activeBooking: activeBooking,
          hasActiveSubscription: hasActiveSub,
          lineDistances: lineDistances,
        ));
      }
    } catch (e, stack) {
      if (!isClosed) emit(StudentDashboardError('Error loading dashboard: $e'));
      log('Dashboard error: $e\n$stack');
    }
  }

  void _listenToRealtime() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Listen to subscriptions table
    _subscriptionsChannel = supabase
        .channel('student_subscriptions_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'subscriptions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'student_id',
            value: userId,
          ),
          callback: (payload) {
            log('Realtime: subscription changed');
            _loadData();
          },
        )
        .subscribe();

    // Listen to bookings table
    _bookingsChannel = supabase
        .channel('student_bookings_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'student_id',
            value: userId,
          ),
          callback: (payload) {
            log('Realtime: booking changed');
            _loadData();
          },
        )
        .subscribe();
  }

  @override
  Future<void> close() async {
    await _subscriptionsChannel?.unsubscribe();
    await _bookingsChannel?.unsubscribe();
    return super.close();
  }
}
