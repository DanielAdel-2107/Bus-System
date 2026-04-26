import 'package:bus_system/features/student/dashboard/view_models/student_dashboard_cubit/student_dashboard_cubit.dart';
import 'package:bus_system/features/student/dashboard/views/widgets/student_dashboard_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentDashboardCubit()..fetchDashboardData(),
      child: const Scaffold(
        body: SafeArea(
          child: StudentDashboardBody(),
        ),
      ),
    );
  }
}