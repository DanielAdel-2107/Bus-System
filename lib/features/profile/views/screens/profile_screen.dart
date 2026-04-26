import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/profile/view_models/profile_cubit/profile_cubit.dart';
import 'package:bus_system/features/profile/views/widgets/profile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  final bool isRoot;
  const ProfileScreen({super.key, this.isRoot = true});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocProvider(
      create: (context) => ProfileCubit()..fetchProfile(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB), // Elegant background
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          leading: isRoot
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
          centerTitle: true,
          title: Text(
            'My Profile',
            style: TextStyle(
              fontSize: SizeConfig.height * 0.024,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: const ProfileScreenBody(),
      ),
    );
  }
}
