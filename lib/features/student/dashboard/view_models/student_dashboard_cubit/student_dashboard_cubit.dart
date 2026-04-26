import 'dart:developer' show log;
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'student_dashboard_state.dart';

class StudentDashboardCubit extends Cubit<StudentDashboardState> {
  StudentDashboardCubit() : super(StudentDashboardInitial());

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchDashboardData() async {
    emit(StudentDashboardLoading());

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

      // 2. Student name
      String studentName = 'Student';
      final profile = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .maybeSingle();

      if (profile != null && profile['full_name'] != null) {
        studentName = profile['full_name'] as String;
      }

      // 3. Coordinates (temporary - replace with geolocator later)
      const double userLat = 26.5569;
      const double userLng = 31.7000;

      // 4. Nearest pickup (using RPC for the specific 'Nearest' section)
      Map<String, dynamic> nearestPickup = {
        'location': 'No nearby points',
        'distance': '',
        'next_bus_time': 'Not available',
      };

      try {
        final nearestResList = await supabase.rpc('get_nearest_pickup', params: {
          'student_lat': userLat,
          'student_lng': userLng,
        });

        if (nearestResList is List && nearestResList.isNotEmpty) {
          final nearestRes = nearestResList.first;
          final distMeters = nearestRes['distance_meters'] as num?;
          nearestPickup = {
            'location': nearestRes['name'] ?? nearestRes['address'] ?? 'Unknown',
            'distance': _formatDistance(distMeters),
            'next_bus_time': '07:30 AM',
          };
        }
      } catch (e) {
        log('Error fetching nearest pickup via RPC: $e');
      }

      // 5. Available Trips (Fetch directly from pickup_points as requested)
      List<Map<String, dynamic>> availablePickups = [];

      try {
        final ppRes = await supabase
            .from('pickup_points')
            .select('id, name, address, latitude, longitude');

        if (ppRes is List) {
          final List<Map<String, dynamic>> trips = [];
          
          for (var pp in ppRes) {
            double? distKm;
            if (pp['latitude'] != null && pp['longitude'] != null) {
              distKm = _calculateDistance(
                userLat, 
                userLng, 
                (pp['latitude'] as num).toDouble(), 
                (pp['longitude'] as num).toDouble()
              );
            }

            trips.add({
              'pickup_id':   pp['id']?.toString() ?? '',
              'driver_id':   '', // Simplified for now
              'area':        pp['name'] ?? 'Unknown area',
              'point':       pp['address'] ?? '',
              'bus':         'Available Point',
              'driver':      'View Details',
              'total_seats': 0,
              'distance_val': distKm ?? 999999.0,
              'distance':    _formatDistanceKm(distKm),
            });
          }

          // Sort by distance (nearest first)
          trips.sort((a, b) => (a['distance_val'] as double).compareTo(b['distance_val'] as double));
          availablePickups = trips;
        }
      } catch (e) {
        log('Error fetching available trips from pickup_points: $e');
      }

      // 6. Active / latest booking
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
            'pickup': pickupPoint?['name']?.toString() ?? pickupPoint?['address']?.toString() ?? '—',
            'driver': driverProfile?['full_name']?.toString() ?? 'Unknown',
            'time': bookingRes['booking_date']?.toString() ?? '—',
            'status': (bookingRes['status'] as String? ?? 'booked').toUpperCase(),
            'seat': bookingRes['seat_number'],
          };
        }
      } catch (e) {
        log('Error fetching latest booking: $e');
      }

      emit(StudentDashboardLoaded(
        studentName: studentName,
        subscription: subscription,
        nearestPickup: nearestPickup,
        availablePickups: availablePickups,
        activeBooking: activeBooking,
        hasActiveSubscription: hasActiveSub,
      ));
    } catch (e, stack) {
      emit(StudentDashboardError('Error loading dashboard: $e'));
      log('Dashboard error: $e\n$stack');
    }
  }

  String _formatDistance(num? meters) {
    if (meters == null || meters <= 0) return '';
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  String _formatDistanceKm(double? km) {
    if (km == null || km <= 0) return 'Not available';
    if (km < 1) return '${(km * 1000).toStringAsFixed(0)} m';
    return '${km.toStringAsFixed(1)} km';
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
