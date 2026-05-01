import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/university/pickup_management/models/pickup_model.dart';
import 'package:bus_system/features/university/pickup_management/view_models/manage_pickup_cubit/manage_pickup_cubit.dart';
import 'package:bus_system/features/university/pickup_management/views/widgets/add_edit_pickup_sheet.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickupCard extends StatelessWidget {
  final PickupPoint pickup;
  final int index;

  const PickupCard({super.key, required this.pickup, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLocationSidebar(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width * 0.05,
                        vertical: SizeConfig.height * 0.025,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  pickup.name,
                                  style: TextStyle(
                                    fontSize: getResponsiveFontSize(
                                      fontSize: 18,
                                    ),
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              _buildActionMenu(context),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.005),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: AppColors.kPrimaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  pickup.address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: getResponsiveFontSize(
                                      fontSize: 14,
                                    ),
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.height * 0.012),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (pickup.lineName != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getLineColor(
                                      pickup.lineName!,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getLineColor(
                                        pickup.lineName!,
                                      ).withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getLineIcon(pickup.lineName!),
                                        color: _getLineColor(pickup.lineName!),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          '${pickup.lineName} Line',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: getResponsiveFontSize(
                                              fontSize: 11,
                                            ),
                                            color: _getLineColor(
                                              pickup.lineName!,
                                            ),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: pickup.isAssigned
                                      ? const Color(0xFFE8F5E9)
                                      : const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      pickup.isAssigned
                                          ? Icons.verified_user_rounded
                                          : Icons.info_outline_rounded,
                                      color: pickup.isAssigned
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        pickup.isAssigned
                                            ? 'Driver: ${pickup.driverName}'
                                            : 'Waiting for Driver',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: getResponsiveFontSize(
                                            fontSize: 11,
                                          ),
                                          color: pickup.isAssigned
                                              ? Colors.green.shade800
                                              : Colors.orange.shade800,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .slideY(begin: 0.1, duration: 400.ms, delay: (index * 80).ms)
        .fadeIn();
  }

  Widget _buildLocationSidebar() {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.05),
        border: Border(
          right: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                    duration: 1000.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeOut(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimaryColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '#${index + 1}',
            style: TextStyle(
              color: AppColors.kPrimaryColor.withOpacity(0.5),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) => BlocProvider.value(
              value: context.read<ManagePickupCubit>(),
              child: AddEditPickupSheet(pickup: pickup),
            ),
          );
        } else if (value == 'delete') {
          CustomQuickAlert.warning(
            title: 'Remove Point?',
            message: 'Are you sure you want to delete this pickup point?',
            confirmText: 'Yes, Delete',
            onConfirm: () {
              CustomQuickAlert.dismiss();
              context.read<ManagePickupCubit>().deletePickup(pickup.id!);
            },
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: AppColors.kPrimaryColor,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Text(
                'Update Details',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_sweep_rounded,
                color: Colors.redAccent,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Remove Point',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getLineColor(String line) {
    switch (line) {
      case 'Mokattam':
        return const Color(0xFF6366F1);
      case 'Nasr City':
        return const Color(0xFFF59E0B);
      case '6 October':
        return const Color(0xFF10B981);
      default:
        return AppColors.kPrimaryColor;
    }
  }

  IconData _getLineIcon(String line) {
    switch (line) {
      case 'Mokattam':
        return Icons.terrain_rounded;
      case 'Nasr City':
        return Icons.location_city_rounded;
      case '6 October':
        return Icons.apartment_rounded;
      default:
        return Icons.directions_bus_rounded;
    }
  }
}
