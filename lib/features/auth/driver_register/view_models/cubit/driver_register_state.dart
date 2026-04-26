import 'package:bus_system/features/auth/driver_register/models/pickup_point_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DriverRegisterState {}

class DriverRegisterInitial extends DriverRegisterState {}

class DriverRegisterLoading extends DriverRegisterState {}

class DriverRegisterSuccess extends DriverRegisterState {}

class DriverRegisterFailure extends DriverRegisterState {
  final String errorMessage;

  DriverRegisterFailure({required this.errorMessage});
}

class PickupPointsLoaded extends DriverRegisterState {
  final List<PickupPointModel> pickupPoints;

  PickupPointsLoaded({required this.pickupPoints});
}

class PickupPointsLoading extends DriverRegisterState {}

class PickupPointSelectedState extends DriverRegisterState {
  final PickupPointModel pickupPoint;

  PickupPointSelectedState({required this.pickupPoint});
}
