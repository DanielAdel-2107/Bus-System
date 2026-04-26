import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/student/nearest_pickups/models/pickup_point_model.dart';
import 'package:flutter/material.dart';

class PickupCard extends StatelessWidget {
  final PickupPoint point;
  final VoidCallback onTrackPressed;
  final VoidCallback onSelectPressed;

  const PickupCard({
    super.key,
    required this.point,
    required this.onTrackPressed,
    required this.onSelectPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isNearest = point.isNearest;

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.025),
        border: Border.all(
          color: isNearest
              ? AppColors.kPrimaryColor.withOpacity(0.6)
              : Colors.grey.withOpacity(0.15),
          width: isNearest ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isNearest
                ? AppColors.kPrimaryColor.withOpacity(0.12)
                : Colors.black.withOpacity(0.04),
            blurRadius: isNearest ? 20 : 15,
            offset: Offset(0, SizeConfig.height * 0.01),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.025),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.height * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNearest) const NearestBadge(),
                PickupNameAndDistance(point: point),
                SizedBox(height: SizeConfig.height * 0.02),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                SizedBox(height: SizeConfig.height * 0.02),
                PickupInfoRow(point: point),
                SizedBox(height: SizeConfig.height * 0.012),
                Row(
                  children: [
                    Icon(
                      Icons.person_pin_circle_rounded,
                      size: SizeConfig.height * 0.022,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: SizeConfig.width * 0.02),
                    Expanded(
                      child: Text(
                        point.driverName.isEmpty
                            ? 'Unknown Driver'
                            : point.driverName,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(fontSize: 15),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.height * 0.025),
                ActionButtonsRow(
                  onSelect: onSelectPressed,
                  onTrack: onTrackPressed,
                  isAvailable: point.driverId.isNotEmpty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NearestBadge extends StatelessWidget {
  const NearestBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.03,
        vertical: SizeConfig.height * 0.006,
      ),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars_rounded,
            size: SizeConfig.height * 0.02,
            color: AppColors.kPrimaryColor,
          ),
          SizedBox(width: SizeConfig.width * 0.015),
          Text(
            "NEAREST TO YOU",
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 12),
              fontWeight: FontWeight.w700,
              color: AppColors.kPrimaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class PickupNameAndDistance extends StatelessWidget {
  final PickupPoint point;

  const PickupNameAndDistance({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    final double dist = point.distanceKm;
    final String parsedDistance = dist < 1.0
        ? "${(dist * 1000).toInt()} m"
        : "${dist.toStringAsFixed(1)} km";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            point.name,
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 20),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.03),
        Text(
          parsedDistance,
          style: TextStyle(
            fontSize: getResponsiveFontSize(fontSize: 20),
            fontWeight: FontWeight.w700,
            color: AppColors.kPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class PickupInfoRow extends StatelessWidget {
  final PickupPoint point;

  const PickupInfoRow({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    String safeBusNumber = point.busNumber.replaceAll('#', '').trim();
    if (safeBusNumber.isEmpty) safeBusNumber = 'Unknown';

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.02),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.directions_bus_rounded,
            color: AppColors.kPrimaryColor,
            size: SizeConfig.height * 0.024,
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.03),
        Expanded(
          child: Text(
            "Bus $safeBusNumber",
            style: TextStyle(
              fontSize: getResponsiveFontSize(fontSize: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8), // Replaced spacer with fixed spacing or wrap the second block differently

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.03,
            vertical: SizeConfig.height * 0.007,
          ),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(SizeConfig.height * 0.04),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_rounded,
                size: SizeConfig.height * 0.02,
                color: AppColors.kPrimaryColor,
              ),
              SizedBox(width: SizeConfig.width * 0.015),
              Text(
                point.time,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(fontSize: 14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onSelect;
  final VoidCallback onTrack;
  final bool isAvailable;

  const ActionButtonsRow({
    super.key,
    required this.onSelect,
    required this.onTrack,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: isAvailable ? AppColors.kPrimaryColor : Colors.grey,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.height * 0.018,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
              ),
            ),
            child: Text(
              isAvailable ? "Select Pickup" : "Unavailable",
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.03),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTrack,
            borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
            child: Container(
              padding: EdgeInsets.all(SizeConfig.height * 0.018),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
              ),
              child: Icon(
                Icons.my_location_rounded,
                color: AppColors.kPrimaryColor,
                size: SizeConfig.height * 0.03,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
