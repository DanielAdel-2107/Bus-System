import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentRegisterHeader extends StatelessWidget {
  const StudentRegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Hero(
            tag: 'logo',
            child: Container(
              width: SizeConfig.width * 0.35,
              height: SizeConfig.width * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBlue.withOpacity(0.2),
                  width: 10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Image.asset(
                AppImages.logoImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

        SizedBox(height: SizeConfig.height * 0.04),

        Text(
          'Student Profile 🎓',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

        Text(
          'Help us personalize your experience.',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
      ],
    );
  }
}
