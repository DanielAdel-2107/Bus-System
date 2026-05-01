part of 'bus_line_cubit.dart';

abstract class BusLineState {}

class BusLineInitial extends BusLineState {}

class BusLineLoading extends BusLineState {
  final String message;
  BusLineLoading(this.message);
}

class BusLineLoaded extends BusLineState {
  final List<PickupPoint> pickupPoints;
  BusLineLoaded(this.pickupPoints);
}

class BusLineError extends BusLineState {
  final String message;
  BusLineError(this.message);
}

class BusLineLocationPermissionDenied extends BusLineState {}
class BusLineLocationServicesDisabled extends BusLineState {}
