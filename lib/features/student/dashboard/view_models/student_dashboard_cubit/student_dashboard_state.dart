part of 'student_dashboard_cubit.dart';

abstract class StudentDashboardState {}

class StudentDashboardInitial extends StudentDashboardState {}

class StudentDashboardLoading extends StudentDashboardState {}

class StudentDashboardLoaded extends StudentDashboardState {
  final String studentName;
  final Map<String, dynamic> subscription;
  final Map<String, dynamic> activeBooking;
  final bool hasActiveSubscription;
  final Map<String, double> lineDistances;

  StudentDashboardLoaded({
    required this.studentName,
    required this.subscription,
    required this.activeBooking,
    required this.hasActiveSubscription,
    this.lineDistances = const {},
  });
}

class StudentDashboardError extends StudentDashboardState {
  final String message;
  StudentDashboardError(this.message);
}
