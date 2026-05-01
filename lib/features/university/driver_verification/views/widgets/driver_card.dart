import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/university/driver_verification/models/driver_model.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_cubit.dart';
import 'package:bus_system/features/university/driver_verification/view_models/driver_verification_cubit/driver_verification_state.dart';
import 'package:bus_system/features/university/pickup_management/models/pickup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;
  final int index;

  const DriverCard({super.key, required this.driver, required this.index});

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
        )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .slideX(begin: 0.2, curve: Curves.easeOut);
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
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
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
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.kPrimaryColor,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem(
              Icons.badge_rounded,
              'License',
              driver.licenseNumber ?? 'N/A',
            ),
            _buildInfoItem(
              Icons.directions_bus_rounded,
              'Bus',
              driver.busNumber ?? 'N/A',
            ),
            _buildInfoItem(
              Icons.event_seat_rounded,
              'Seats',
              driver.totalSeats?.toString() ?? '0',
            ),
          ],
        ),
        if (driver.status == 'accepted' &&
            (driver.lineName != null || driver.pickupPointName != null)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Pickup Point',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        driver.pickupPointName ?? 'No Point Assigned',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (driver.lineName != null)
                        Text(
                          '${driver.lineName} Line',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
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
        if (status != 'rejected') const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label: status == 'accepted' ? 'Edit Assignment' : 'Approve',
            onTap: () => _showLineSelectionDialog(context),
            color: status == 'accepted'
                ? AppColors.kPrimaryColor
                : Colors.greenAccent.shade700,
            icon: status == 'accepted' ? Icons.edit_note_rounded : Icons.check_rounded,
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  void _showLineSelectionDialog(BuildContext context) {
    final cubit = context.read<DriverVerificationCubit>();
    final lines = [
      {
        'name': 'Mokattam',
        'icon': Icons.terrain_rounded,
        'color': const Color(0xFF6366F1),
      },
      {
        'name': 'Nasr City',
        'icon': Icons.location_city_rounded,
        'color': const Color(0xFFF59E0B),
      },
      {
        'name': '6 October',
        'icon': Icons.apartment_rounded,
        'color': const Color(0xFF10B981),
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Assign Bus Line',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 20),
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select the line for ${driver.fullName}',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ...lines.map((line) {
                final color = line['color'] as Color;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showPickupPointSelectionDialog(
                      context,
                      cubit,
                      line['name'] as String,
                      color,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            line['icon'] as IconData,
                            color: color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${line['name']} Line',
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(fontSize: 16),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: color,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showPickupPointSelectionDialog(
    BuildContext context,
    DriverVerificationCubit cubit,
    String lineName,
    Color color,
  ) {
    cubit.fetchPickupPoints(lineName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Pickup Point',
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(fontSize: 20),
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Points available for $lineName Line',
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(fontSize: 14),
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<DriverVerificationCubit, DriverVerificationState>(
                    builder: (context, state) {
                      if (state is DriverVerificationSuccess &&
                          state.isFetchingPickups) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is DriverVerificationSuccess) {
                        if (state.pickupPoints.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off_rounded,
                                  size: 48,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No points found for this line',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.pickupPoints.length,
                          itemBuilder: (context, index) {
                            final point = state.pickupPoints[index];
                            final isAssigned = point.isAssigned;

                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                CustomQuickAlert.loading(
                                  title: 'Please wait',
                                  message: 'Approving driver...',
                                );
                                cubit.approveDriver(
                                  driver.id,
                                  lineName,
                                  point.id!,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isAssigned
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isAssigned
                                        ? Colors.grey.shade200
                                        : color.withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isAssigned
                                            ? Colors.grey.shade200
                                            : color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.location_on_rounded,
                                        color: isAssigned
                                            ? Colors.grey.shade400
                                            : color,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            point.name,
                                            style: TextStyle(
                                              fontSize: getResponsiveFontSize(
                                                fontSize: 15,
                                              ),
                                              fontWeight: FontWeight.w700,
                                              color: isAssigned
                                                  ? Colors.grey.shade400
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                isAssigned
                                                    ? Icons
                                                          .verified_user_rounded
                                                    : Icons
                                                          .info_outline_rounded,
                                                color: isAssigned
                                                    ? Colors.green.shade600
                                                    : Colors.orange.shade600,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                isAssigned
                                                    ? 'Driver: ${point.driverName}'
                                                    : 'No driver yet',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isAssigned
                                                      ? Colors.green.shade700
                                                      : Colors.orange.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 20,
                                      color: isAssigned
                                          ? Colors.grey.shade300
                                          : color.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
