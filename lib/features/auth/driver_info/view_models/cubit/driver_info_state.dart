part of 'driver_info_cubit.dart';

@immutable
abstract class DriverInfoState {}

class DriverInfoInitial extends DriverInfoState {}

class DriverInfoLoading extends DriverInfoState {}

class DriverInfoSuccess extends DriverInfoState {}

class DriverInfoFailure extends DriverInfoState {
  final String errorMessage;

  DriverInfoFailure({required this.errorMessage});
}

class PickupPointSelected extends DriverInfoState {
  final String pickupPoint;

  PickupPointSelected({required this.pickupPoint});
}
