import 'package:bloc/bloc.dart';
import 'package:bus_system/features/student/nearest_pickups/models/pickup_point_model.dart';
import 'package:bus_system/features/student/nearest_pickups/view_models/cubit/nearest_pickups_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NearestPickupsCubit extends Cubit<NearestPickupsState> {
  NearestPickupsCubit() : super(NearestPickupsInitial());

  Future<void> loadData() async {
    emit(const NearestPickupsLoading("Checking location services..."));
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(NearestPickupsLocationServicesDisabled());
      return;
    }

    // ── 2. التحقق من الإذن ──
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(NearestPickupsLocationPermissionDenied());
        return;
      }
    }

    emit(const NearestPickupsLoading("Fetching your current location..."));

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await Supabase.instance.client.rpc(
        'get_nearest_pickup_points',
        params: {
          'p_user_lat': position.latitude,
          'p_user_lon': position.longitude,
          'p_limit': 10,
        },
      );

      if (response == null || (response as List).isEmpty) {
        emit(const NearestPickupsLoaded([]));
        return;
      }

      final List<PickupPoint> items = [];
      final defaultTimes = ['07:20 AM', '07:35 AM', '07:50 AM', '08:05 AM'];

      for (int i = 0; i < response.length; i++) {
        final row = response[i] as Map<String, dynamic>;

        final name = row['pickup_name'] as String? ?? 'Unknown';
        final lat = (row['latitude'] as num?)?.toDouble() ?? 0.0;
        final lng = (row['longitude'] as num?)?.toDouble() ?? 0.0;
        final distance = (row['distance_km'] as num?)?.toDouble() ?? 999.9;
        final bus = row['bus_number'] as String? ?? 'No Bus Assigned';
        final driver = row['driver_name'] as String? ?? 'No Driver';
        final driverId = row['driver_id'] as String? ?? '';

        if (driverId.isEmpty) continue; // لا تقم بعرض نقاط لم يعين لها سائق

        items.add(
          PickupPoint(
            name: name,
            driverId: driverId,
            position: LatLng(lat, lng),
            distanceKm: distance,
            time: i < defaultTimes.length ? defaultTimes[i] : '08:30 AM',
            busNumber: bus,
            driverName: driver,
            isNearest: i == 0,
          ),
        );
      }

      emit(NearestPickupsLoaded(items));
    } catch (e) {
      emit(NearestPickupsError("حدث خطأ أثناء جلب البيانات\n\$e"));
    }
  }
}
