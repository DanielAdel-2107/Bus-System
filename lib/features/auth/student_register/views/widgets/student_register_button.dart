import 'package:bus_system/core/components/custom_elevated_button.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StudentRegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StudentRegisterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: onPressed,
      name: 'Complete Profile',
      backgroundColor: AppColors.primaryBlue,
      width: SizeConfig.width * 0.85,
      height: SizeConfig.height * 0.065,
    ).animate().scale(delay: 800.ms, duration: 400.ms, curve: Curves.elasticOut);
  }
}
