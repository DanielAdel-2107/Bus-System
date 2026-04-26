import 'package:bus_system/features/auth/student_register/view_models/cubit/student_register_cubit.dart';
import 'package:bus_system/features/auth/student_register/views/widgets/student_register_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegisterScreen extends StatelessWidget {
  const StudentRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentRegisterCubit(),
      child: const Scaffold(
        body: StudentRegisterScreenBody(),
      ),
    );
  }
}
