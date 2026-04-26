import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.04,
        vertical: SizeConfig.height * 0.018,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
        boxShadow: Theme.of(context).brightness == Brightness.dark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.height * 0.014),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: SizeConfig.height * 0.024,
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(fontSize: 16),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: SizeConfig.height * 0.004),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(fontSize: 13),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.kPrimaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
