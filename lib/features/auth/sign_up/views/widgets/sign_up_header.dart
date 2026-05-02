import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: SizeConfig.width * 0.45,
          height: SizeConfig.width * 0.45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.lightBlue.withOpacity(0.3),
              width: 14,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.2),
                blurRadius: 60,
                spreadRadius: 15,
              ),
            ],
          ),
          child: Image.asset(
            AppImages.logoImage,
            fit: BoxFit.contain,
          ),
        )
            .animate()
            .scale(duration: 800.ms, curve: Curves.easeOutBack)
            .then()
            .shimmer(duration: 1400.ms),

        SizedBox(height: SizeConfig.height * 0.03),

        Text(
          'Create New Account 👋',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

        Text(
          'Join thousands of students & parents',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
      ],
    );
  }
}
