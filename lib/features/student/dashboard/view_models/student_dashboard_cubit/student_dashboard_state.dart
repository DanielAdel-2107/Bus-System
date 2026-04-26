part of 'student_dashboard_cubit.dart';

abstract class StudentDashboardState {}

class StudentDashboardInitial extends StudentDashboardState {}

class StudentDashboardLoading extends StudentDashboardState {}

class StudentDashboardLoaded extends StudentDashboardState {
  final String studentName;
  final Map<String, dynamic> subscription;
  final Map<String, dynamic> nearestPickup;
  final List<Map<String, dynamic>> availablePickups;
  final Map<String, dynamic> activeBooking;
  final bool hasActiveSubscription;

  StudentDashboardLoaded({
    required this.studentName,
    required this.subscription,
    required this.nearestPickup,
    required this.availablePickups,
    required this.activeBooking,
    required this.hasActiveSubscription,
  });
}

class StudentDashboardError extends StudentDashboardState {
  final String message;
  StudentDashboardError(this.message);
}
