import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatisticsCards extends StatelessWidget {
  final int totalSeats;
  final int occupiedSeats;

  const StatisticsCards({
    super.key,
    required this.totalSeats,
    required this.occupiedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Seats',
            value: totalSeats.toString(),
            icon: Icons.event_seat_rounded,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.04),
        Expanded(
          child: _buildStatCard(
            title: 'Occupied',
            value: occupiedSeats.toString(),
            icon: Icons.people_alt_rounded,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: SizeConfig.width * 0.06),
              ),
              Icon(
                Icons.trending_up_rounded,
                color: Colors.grey.withOpacity(0.4),
                size: SizeConfig.width * 0.05,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Text(
            value,
            style: AppTextStyles.title24WhiteW500.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.005),
          Text(
            title,
            style: AppTextStyles.title14Grey.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
