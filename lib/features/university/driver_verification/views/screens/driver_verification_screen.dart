import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_cubit.dart';
import 'package:bus_system/features/university/driver_verification/views/widgets/driver_verification_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverVerificationScreen extends StatelessWidget {
  const DriverVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverVerificationCubit()..watchDrivers(),
      child: const Scaffold(
        body: DriverVerificationScreenBody(),
      ),
    );
  }
}
