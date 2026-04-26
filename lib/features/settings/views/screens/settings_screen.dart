import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/settings/views/widgets/settings_screen_body.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isRoot;
  const SettingsScreen({super.key, this.isRoot = true});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: SizeConfig.height * 0.026,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: isRoot
            ? null
            : IconButton(
                icon: Container(
                  padding: EdgeInsets.all(SizeConfig.height * 0.01),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.kPrimaryColor,
                    size: SizeConfig.height * 0.02,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: const SettingsScreenBody(),
    );
  }
}
