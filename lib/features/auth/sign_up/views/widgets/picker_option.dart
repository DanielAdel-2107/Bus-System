import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/extensions/app_extensions.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';

class PickerOption extends StatelessWidget {
  const PickerOption({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.kPrimaryColor),
      title: Text(label),
      trailing: Icon(Icons.arrow_forward_ios, size: SizeConfig.width * 0.04),
      onTap: () {
        context.popScreen();
        onTap?.call();
      },
    );
  }
}
