import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/features/student/nearest_pickups/view_models/cubit/nearest_pickups_cubit.dart';
import 'package:bus_system/features/student/nearest_pickups/views/widgets/nearest_pickups_screen_body.dart';

class NearestPickupsScreen extends StatelessWidget {
  const NearestPickupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NearestPickupsCubit()..loadData(),
      child: const NearestPickupsScreenBody(),
    );
  }
}
