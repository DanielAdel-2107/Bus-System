import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DriverBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DriverBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height * 0.08,
      margin: EdgeInsets.fromLTRB(
        SizeConfig.width * 0.06,
        0,
        SizeConfig.width * 0.06,
        SizeConfig.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.dashboard_rounded, 'Home'),
          _buildNavItem(1, Icons.people_alt_rounded, 'Passengers'),
          _buildNavItem(2, Icons.person_rounded, 'Profile'),
          _buildNavItem(3, Icons.settings_rounded, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? SizeConfig.width * 0.04 : SizeConfig.width * 0.02,
          vertical: SizeConfig.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.kPrimaryColor : Colors.grey.shade400,
              size: SizeConfig.height * 0.03,
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.width * 0.02),
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.height * 0.016,
                  ),
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
          ],
        ),
      ),
    );
  }
}
