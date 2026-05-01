import 'dart:developer' show log;
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  address
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
            'driver': driverProfile?['full_name']?.toString() ?? 'Unknown',
            'time': bookingRes['booking_date']?.toString() ?? '—',
            'status': (bookingRes['status'] as String? ?? 'booked').toUpperCase(),
            'seat': bookingRes['seat_number'],
          };
        }
      } catch (e) {
        log('Error fetching latest booking: $e');
      }

      if (!isClosed) {
        emit(StudentDashboardLoaded(
          studentName: _cachedStudentName,
          subscription: subscription,
          activeBooking: activeBooking,
          hasActiveSubscription: hasActiveSub,
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
