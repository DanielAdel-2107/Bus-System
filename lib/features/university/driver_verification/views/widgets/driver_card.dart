import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/university/driver_verification/models/driver_model.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;
  final int index;

  const DriverCard({
    super.key,
    required this.driver,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            _buildStatusIndicator(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(height: 30, thickness: 0.5),
                  _buildDetails(),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2, curve: Curves.easeOut);
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;
    String label;

    switch (driver.status) {
      case 'accepted':
        color = Colors.green;
        icon = Icons.verified_rounded;
        label = 'ACCEPTED';
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.block_flipped;
        label = 'REJECTED';
        break;
      default:
        color = Colors.orange;
        icon = Icons.pending_rounded;
        label = 'PENDING';
    }

    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_rounded, color: AppColors.kPrimaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver.fullName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: getResponsiveFontSize(fontSize: 18),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                driver.phone ?? 'No Phone Provided',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(Icons.badge_rounded, 'License', driver.licenseNumber ?? 'N/A'),
        _buildInfoItem(Icons.directions_bus_rounded, 'Bus', driver.busNumber ?? 'N/A'),
        _buildInfoItem(Icons.event_seat_rounded, 'Seats', driver.totalSeats?.toString() ?? '0'),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = driver.status;
    return Row(
      children: [
        if (status != 'rejected')
          Expanded(
            child: _buildActionButton(
              label: 'Reject',
              onTap: () {
                CustomQuickAlert.loading(
                  title: 'Please wait',
                  message: 'Updating driver status...',
                );
                context.read<DriverVerificationCubit>().rejectDriver(driver.id);
              },
              color: Colors.redAccent,
              icon: Icons.close_rounded,
            ),
          ),
        if (status == 'pending') const SizedBox(width: 12),
        if (status != 'accepted')
          Expanded(
            child: _buildActionButton(
              label: 'Approve',
              onTap: () {
                CustomQuickAlert.loading(
                  title: 'Please wait',
                  message: 'Updating driver status...',
                );
                context.read<DriverVerificationCubit>().approveDriver(driver.id);
              },
              color: Colors.greenAccent.shade700,
              icon: Icons.check_rounded,
              isPrimary: true,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isPrimary ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isPrimary ? Colors.white : color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
