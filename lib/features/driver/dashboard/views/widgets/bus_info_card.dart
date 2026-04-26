import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BusInfoCard extends StatelessWidget {
  final String busNumber;
  final String licenseNumber;

  const BusInfoCard({
    super.key,
    required this.busNumber,
    required this.licenseNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.width * 0.05),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.directions_bus_filled_rounded,
                  color: Colors.white,
                  size: SizeConfig.width * 0.07,
                ),
              ),
              SizedBox(width: SizeConfig.width * 0.04),
              Expanded(
                child: Text(
                  'Bus Information',
                  style: AppTextStyles.title20WhiteW500.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                Icons.verified,
                color: Colors.white.withOpacity(0.9),
                size: SizeConfig.width * 0.06,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.pin_outlined, 'Bus Number', busNumber),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
                ),
                _buildInfoRow(Icons.badge_outlined, 'License', licenseNumber),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut).slideX(begin: -0.2, curve: Curves.easeOut);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 22),
        SizedBox(width: SizeConfig.width * 0.03),
        Text(
          label,
          style: AppTextStyles.title14White70.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.title16WhiteW600.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
