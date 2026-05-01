import 'package:bus_system/features/university/pickup_management/models/pickup_model.dart';
import 'package:equatable/equatable.dart';

abstract class ManagePickupState extends Equatable {
  const ManagePickupState();

  @override
  List<Object?> get props => [];
}

class ManagePickupInitial extends ManagePickupState {}

class ManagePickupLoading extends ManagePickupState {}

class ManagePickupSuccess extends ManagePickupState {
  final List<PickupPoint> pickups;

  const ManagePickupSuccess(this.pickups);

  @override
  List<Object?> get props => [pickups];
}

class ManagePickupActionLoading extends ManagePickupState {}

class ManagePickupActionSuccess extends ManagePickupState {
  final String message;

  const ManagePickupActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ManagePickupError extends ManagePickupState {
  final String message;

  const ManagePickupError(this.message);

  @override
  List<Object?> get props => [message];
}
