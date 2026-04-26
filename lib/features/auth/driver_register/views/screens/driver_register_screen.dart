import 'package:bus_system/features/auth/driver_register/view_models/cubit/driver_register_cubit.dart';
import 'package:bus_system/features/auth/driver_register/views/widgets/driver_register_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverRegisterScreen extends StatelessWidget {
  const DriverRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverRegisterCubit()..fetchPickupPoints(),
      child: const Scaffold(
        body: DriverRegisterScreenBody(),
      ),
    );
  }
}
