import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'About Us',
          style: TextStyle(
            fontSize: getResponsiveFontSize(fontSize: 20),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.height * 0.03),
            Center(
              child: Container(
                width: SizeConfig.width * 0.35,
                height: SizeConfig.width * 0.35,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: SizeConfig.width * 0.18,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
            ),
            SizedBox(height: SizeConfig.height * 0.04),
            Text(
              'Bus System v1.0.0',
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 22),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms),
            SizedBox(height: SizeConfig.height * 0.02),
            Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.06),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                'Welcome to our advanced Bus Tracking & Management System. This app is designed to provide seamless real-time tracking, seat management, and safe transportation for students and university staff. Our mission is to transform commute into a safe, reliable, and technologically advanced experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 15),
                  height: 1.6,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).animate().slideY(begin: 0.2, duration: 600.ms).fadeIn(),
            SizedBox(height: SizeConfig.height * 0.04),
            _buildFeatureRow(Icons.security_rounded, 'Safety First Infrastructure'),
            _buildFeatureRow(Icons.gps_fixed_rounded, 'Real-time GPS Monitoring'),
            _buildFeatureRow(Icons.event_seat_rounded, 'Smart Seat Selection'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.height * 0.015),
      child: Row(
        children: [
          Icon(icon, color: AppColors.kPrimaryColor, size: 24),
          SizedBox(width: SizeConfig.width * 0.03),
          Text(
            text,
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ).animate().fadeIn(delay: 800.ms),
    );
  }
}
