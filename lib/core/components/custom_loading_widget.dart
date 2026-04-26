import 'package:bus_system/core/utilies/assets/lotties/app_lotties.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomLoadingWidget extends StatelessWidget {
  final String? message;
  
  const CustomLoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.kPrimaryColor.withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Lottie.asset(
              AppLotties.trackingLocationLottie,
              width: SizeConfig.width * 0.4,
              height: SizeConfig.width * 0.4,
              fit: BoxFit.contain,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.05, 1.05), duration: 2000.ms, curve: Curves.easeInOut),
          
          const SizedBox(height: 30),
          
          Text(
            message ?? 'Processing your request...',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .fadeIn(duration: 1000.ms),
          
          const SizedBox(height: 8),
          
          const Text(
            'Please wait a moment',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }
}
