import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/driver/dashboard/views/screens/driver_dashboard_screen.dart';
import 'package:bus_system/features/driver/driver_main/view_models/driver_main_cubit/driver_main_cubit.dart';
import 'package:bus_system/features/driver/driver_main/view_models/driver_main_cubit/driver_main_state.dart';
import 'package:bus_system/features/driver/driver_main/views/widgets/driver_bottom_nav_bar.dart';
import 'package:bus_system/features/driver/passenger_list/views/screens/passenger_list_screen.dart';
import 'package:bus_system/features/profile/views/screens/profile_screen.dart';
import 'package:bus_system/features/settings/views/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverMainScreen extends StatelessWidget {
  const DriverMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return BlocProvider(
      create: (context) => DriverMainCubit(),
      child: BlocBuilder<DriverMainCubit, DriverMainState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            body: IndexedStack(
              index: state.currentIndex,
              children: const [
                DriverDashboardScreen(),
                PassengerListScreen(),
                ProfileScreen(),
                SettingsScreen(),
              ],
            ),
            bottomNavigationBar: DriverBottomNavBar(
              currentIndex: state.currentIndex,
              onTap: (index) => context.read<DriverMainCubit>().changeTab(index),
            ),
          );
        },
      ),
    );
  }
}
