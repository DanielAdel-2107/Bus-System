import 'package:bloc/bloc.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/network/supabase/database/get_data.dart';
import 'package:bus_system/features/auth/driver_register/models/pickup_point_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'driver_register_state.dart';

class DriverRegisterCubit extends Cubit<DriverRegisterState> {
  DriverRegisterCubit() : super(DriverRegisterInitial());

  final formKey = GlobalKey<FormState>();
  final licenseController = TextEditingController();
  final busNumberController = TextEditingController();
  final totalSeatsController = TextEditingController();
  
  List<PickupPointModel> pickupPoints = [];
  PickupPointModel? selectedPickupPoint;

  Future<void> fetchPickupPoints() async {
    emit(PickupPointsLoading());
    try {
      final data = await getData(tableName: 'pickup_points', orderBy: 'name');
      pickupPoints = data.map((json) => PickupPointModel.fromJson(json)).toList();
      emit(PickupPointsLoaded(pickupPoints: pickupPoints));
    } catch (e) {
      emit(DriverRegisterFailure(errorMessage: e.toString()));
    }
  }

  void selectPickupPoint(PickupPointModel? point) {
    selectedPickupPoint = point;
    if (point != null) {
      emit(PickupPointSelectedState(pickupPoint: point));
    }
  }

  Future<void> submitDriverInfo() async {
    if (formKey.currentState!.validate()) {
      if (selectedPickupPoint == null) {
        emit(DriverRegisterFailure(errorMessage: 'Please select a pickup point'));
        return;
      }

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
          'pickup_point_id': selectedPickupPoint!.id,
          'is_verified': false,
          'status': 'pending', // Explicitly setting it just in case
        });
        emit(DriverRegisterSuccess());
      } catch (e) {
        // Handle specific unique constraint violation for license_number if possible
        String message = e.toString();
        if (message.contains('unique_license_number') || message.contains('duplicate key')) {
          message = 'This license number is already registered.';
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
