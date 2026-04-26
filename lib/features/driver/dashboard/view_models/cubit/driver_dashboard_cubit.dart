import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/features/auth/driver_register/models/driver_model.dart';
import 'package:bus_system/features/driver/dashboard/models/booking_model.dart';
import 'package:bus_system/features/driver/dashboard/view_models/cubit/driver_dashboard_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverDashboardCubit extends Cubit<DriverDashboardState> {
  DriverDashboardCubit() : super(DriverDashboardInitial());

  Future<void> getDashboardData() async {
    try {
      emit(DriverDashboardLoading());

      final client = getIt<SupabaseClient>();
      final user = client.auth.currentUser;

      String driverId;
      if (user == null) {
        // Fallback for testing the UI if bypassing login screen
        final firstDriver = await client
            .from('drivers')
            .select('id')
            .limit(1)
            .maybeSingle();
        if (firstDriver == null)
          throw Exception('No drivers found in the database for testing.');
        driverId = firstDriver['id'].toString();
      } else {
        driverId = user.id;
      }
      final driverResponse = await client
          .from('drivers')
          .select()
          .eq('id', driverId)
          .single();
      log(driverId);
      final driverModel = DriverModel.fromJson(driverResponse);

      // If the driver is not yet verified, show the pending screen
      if (!driverModel.isVerified) {
        emit(DriverDashboardPending(driverInfo: driverModel));
        return;
      }

      final int totalSeats = driverModel.totalSeats;
      final bookingsResponse = await client
          .from('bookings')
          .select('*, profiles!bookings_student_id_profiles_fkey(full_name)')
          .eq('driver_id', driverId);
      final List<Map<String, dynamic>> bookingsData =
          List<Map<String, dynamic>>.from(bookingsResponse);
      final List<BookingModel> bookingModels = bookingsData
          .map((json) => BookingModel.fromJson(json))
          .toList();
      final int occupiedSeats = bookingModels.length;

      emit(
        DriverDashboardSuccess(
          driverInfo: driverModel,
          allBookings: bookingModels,
          totalSeats: totalSeats,
          occupiedSeats: occupiedSeats,
        ),
      );
    } catch (e) {
      emit(DriverDashboardFailure(errorMessage: e.toString()));
    }
  }
}
