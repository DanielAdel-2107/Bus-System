import 'package:bus_system/features/student/nearest_pickups/models/pickup_point_model.dart';
import 'package:equatable/equatable.dart';

abstract class NearestPickupsState extends Equatable {
  const NearestPickupsState();

  @override
  List<Object?> get props => [];
}

class NearestPickupsInitial extends NearestPickupsState {}

class NearestPickupsLoading extends NearestPickupsState {
  final String message;
  const NearestPickupsLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class NearestPickupsLoaded extends NearestPickupsState {
  final List<PickupPoint> pickups;
  const NearestPickupsLoaded(this.pickups);

  @override
  List<Object?> get props => [pickups];
}

class NearestPickupsError extends NearestPickupsState {
  final String message;
  const NearestPickupsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NearestPickupsLocationPermissionDenied extends NearestPickupsState {}

class NearestPickupsLocationServicesDisabled extends NearestPickupsState {}
