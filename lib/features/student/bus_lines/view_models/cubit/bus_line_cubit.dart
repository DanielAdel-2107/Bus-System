import 'package:bloc/bloc.dart';
import 'package:bus_system/features/student/bus_lines/models/pickup_point_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'bus_line_state.dart';

class BusLineCubit extends Cubit<BusLineState> {
  BusLineCubit() : super(BusLineInitial());

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> loadLineDetails(String lineName) async {
    emit(BusLineLoading("Checking location services..."));
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(BusLineLocationServicesDisabled());
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(BusLineLocationPermissionDenied());
        return;
      }
    }

    emit(BusLineLoading("Fetching pickup points for $lineName..."));

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch pickup points for the specific line
      // We also join with drivers to see if there's an active driver for this point
      final response = await _supabase
          .from('pickup_points')
          .select('''
            *,
            drivers (
              id,
              bus_number,
              profiles (
                full_name
              )
            )
          ''')
          .eq('line_name', lineName);

      if (response == null || (response as List).isEmpty) {
        emit(BusLineLoaded([]));
        return;
      }

      final List<PickupPoint> items = [];
      final data = response as List;

      for (var row in data) {
        // Check for assigned driver/bus - ONLY add to list if driver exists
        final drivers = row['drivers'] as List?;
        if (drivers == null || drivers.isEmpty) continue;

        final firstDriver = drivers.first;
        final name = row['name'] as String? ?? 'Unknown';
        final lat = (row['latitude'] as num?)?.toDouble() ?? 0.0;
        final lng = (row['longitude'] as num?)?.toDouble() ?? 0.0;
        
        // Calculate distance from student to this point
        final distanceMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          lat,
          lng,
        );
        final distanceKm = distanceMeters / 1000;

        String bus = firstDriver['bus_number']?.toString() ?? 'No Bus';
        String driverName = firstDriver['profiles']?['full_name']?.toString() ?? 'Unknown';
        String driverId = firstDriver['id']?.toString() ?? '';

        items.add(
          PickupPoint(
            name: name,
            position: LatLng(lat, lng),
            distanceKm: distanceKm,
            driverId: driverId,
            time: "07:30 AM", // Placeholder or fetch from a schedule table if exists
            busNumber: bus,
            driverName: driverName,
          ),
        );
      }

      // Sort by distance
      items.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

      emit(BusLineLoaded(items));
    } catch (e) {
      emit(BusLineError("Error loading line details: $e"));
    }
  }
}
