import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_cubit.dart';
import 'package:bus_system/features/university/pickup_management/views/widgets/manage_pickup_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagePickupScreen extends StatelessWidget {
  const ManagePickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManagePickupCubit()..watchPickups(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Pickup Management',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: 0.5,
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: const ManagePickupScreenBody(),
      ),
    );
  }
}
