import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_cubit.dart';
import 'package:bus_system/features/university/driver_verification/views/widgets/driver_verification_screen_body.dart';
import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_cubit.dart';
import 'package:bus_system/features/university/pickup_management/views/widgets/manage_pickup_screen_body.dart';
import 'package:bus_system/features/university/university_home/views/widgets/university_settings_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UniversityMainScreen extends StatefulWidget {
  final int initialIndex;
  const UniversityMainScreen({super.key, this.initialIndex = 0});

  @override
  State<UniversityMainScreen> createState() => _UniversityMainScreenState();
}

class _UniversityMainScreenState extends State<UniversityMainScreen> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const ManagePickupScreenBody(),
    const DriverVerificationScreenBody(),
    const UniversitySettingsBody(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ManagePickupCubit()..watchPickups()),
        BlocProvider(create: (context) => DriverVerificationCubit()..watchDrivers()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: AppColors.kPrimaryColor.withOpacity(0.15),
            hoverColor: AppColors.kPrimaryColor.withOpacity(0.05),
            gap: 8,
            activeColor: AppColors.kPrimaryColor,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.1),
            color: AppColors.textSecondary,
            tabs: const [
              GButton(
                icon: Icons.location_on_rounded,
                text: 'Pickups',
              ),
              GButton(
                icon: Icons.verified_user_rounded,
                text: 'Drivers',
              ),
              GButton(
                icon: Icons.settings_rounded,
                text: 'Settings',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
