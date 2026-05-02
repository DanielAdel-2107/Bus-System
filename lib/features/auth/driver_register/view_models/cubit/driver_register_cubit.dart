import 'package:bloc/bloc.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/network/supabase/database/get_data.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'driver_register_state.dart';

class DriverRegisterCubit extends Cubit<DriverRegisterState> {
  DriverRegisterCubit() : super(DriverRegisterInitial());

  final formKey = GlobalKey<FormState>();
  final licenseController = TextEditingController();
  final busNumberController = TextEditingController();
  final totalSeatsController = TextEditingController();
  


  Future<void> submitDriverInfo() async {
    if (formKey.currentState!.validate()) {

      emit(DriverRegisterLoading());
      try {
        final user = getIt<SupabaseClient>().auth.currentUser;
        if (user == null) {
          emit(DriverRegisterFailure(errorMessage: 'Authentication error: User session not found. Please sign in again.'));
          return;
        }

        final int? totalSeats = int.tryParse(totalSeatsController.text.trim());
        if (totalSeats == null || totalSeats <= 0) {
          emit(DriverRegisterFailure(errorMessage: 'Please enter a valid number of seats (greater than 0).'));
          return;
        }

        await getIt<SupabaseClient>().from('drivers').upsert({
          'id': user.id,
          'license_number': licenseController.text.trim(),
          'bus_number': busNumberController.text.trim(),
          'total_seats': totalSeats,
          'is_verified': false,
          'status': 'pending', // Explicitly setting it just in case
        });
        emit(DriverRegisterSuccess());
      } catch (e) {
        debugPrint('Driver Register Error: $e');
        String message = e.toString();
        
        // Handle specific unique constraint violation for license_number
        if (message.contains('unique_license_number') || 
            message.contains('duplicate key') || 
            message.contains('drivers_license_number_key')) {
          message = 'This license number is already registered. Please check the number and try again.';
        } else if (message.toLowerCase().contains('session') || message.toLowerCase().contains('auth') || message.toLowerCase().contains('sign in')) {
          message = 'Your session has expired. Please sign in again.';
        }
        
        emit(DriverRegisterFailure(errorMessage: message));
      }
    }
  }

  @override
  Future<void> close() {
    licenseController.dispose();
    busNumberController.dispose();
    totalSeatsController.dispose();
    return super.close();
  }
}
