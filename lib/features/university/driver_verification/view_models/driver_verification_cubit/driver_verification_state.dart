import 'package:bus_system/features/university/driver_verification/models/driver_model.dart';
import 'package:equatable/equatable.dart';

abstract class DriverVerificationState extends Equatable {
  const DriverVerificationState();

  @override
  List<Object?> get props => [];
}

class DriverVerificationInitial extends DriverVerificationState {}

class DriverVerificationLoading extends DriverVerificationState {}

class DriverVerificationSuccess extends DriverVerificationState {
  final List<Driver> allDrivers;
  final String selectedStatus; // 'pending', 'accepted', 'rejected', 'all'
  final String? successMessage;

  const DriverVerificationSuccess({
    required this.allDrivers,
    this.selectedStatus = 'all',
    this.successMessage,
  });

  List<Driver> get filteredDrivers {
    if (selectedStatus == 'all') return allDrivers;
    return allDrivers.where((d) => d.status == selectedStatus).toList();
  }

  DriverVerificationSuccess copyWith({
    List<Driver>? allDrivers,
    String? selectedStatus,
    String? successMessage,
  }) {
    return DriverVerificationSuccess(
      allDrivers: allDrivers ?? this.allDrivers,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [allDrivers, selectedStatus, successMessage];
}

class DriverVerificationError extends DriverVerificationState {
  final String message;
  const DriverVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
