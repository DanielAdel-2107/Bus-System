import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'driver_info_state.dart';

class DriverInfoCubit extends Cubit<DriverInfoState> {
  DriverInfoCubit() : super(DriverInfoInitial());

  final formKey = GlobalKey<FormState>();
  final licenseController = TextEditingController();
  final busNumberController = TextEditingController();
  final totalSeatsController = TextEditingController();
  
  String? selectedPickupPoint;

  void selectPickupPoint(String? value) {
    selectedPickupPoint = value;
    if (value != null) {
      emit(PickupPointSelected(pickupPoint: value));
    }
  }

  void submitInfo() {
    if (formKey.currentState!.validate()) {
      if (selectedPickupPoint == null) {
        emit(DriverInfoFailure(errorMessage: 'Please select a pickup point'));
        return;
      }
      
      emit(DriverInfoLoading());
      // Logic for submitting to Supabase will be added later
      // For now, we just simulate success after a delay
      Future.delayed(const Duration(seconds: 2), () {
        emit(DriverInfoSuccess());
      });
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
