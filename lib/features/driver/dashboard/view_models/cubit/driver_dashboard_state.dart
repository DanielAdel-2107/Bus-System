import 'package:equatable/equatable.dart';
import 'package:bus_system/features/auth/driver_register/models/driver_model.dart';
import 'package:bus_system/features/driver/dashboard/models/booking_model.dart';

sealed class DriverDashboardState extends Equatable {
  const DriverDashboardState();

  @override
  List<Object?> get props => [];
}

final class DriverDashboardInitial extends DriverDashboardState {}

final class DriverDashboardLoading extends DriverDashboardState {}

/// Driver registered but not yet approved by the university
final class DriverDashboardPending extends DriverDashboardState {
  final DriverModel driverInfo;
  const DriverDashboardPending({required this.driverInfo});

  @override
  List<Object?> get props => [driverInfo];
}

final class DriverDashboardSuccess extends DriverDashboardState {
  final DriverModel driverInfo;
  final List<BookingModel> allBookings;
  final int totalSeats;
  final int occupiedSeats;

  const DriverDashboardSuccess({
    required this.driverInfo,
    required this.allBookings,
    required this.totalSeats,
    required this.occupiedSeats,
  });

  @override
  List<Object?> get props => [driverInfo, allBookings, totalSeats, occupiedSeats];
}

final class DriverDashboardFailure extends DriverDashboardState {
  final String errorMessage;

  const DriverDashboardFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
