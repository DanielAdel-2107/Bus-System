import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.waving_hand,
          color: AppColors.kPrimaryColor,
          size: SizeConfig.width * 0.08,
        ),
        SizedBox(width: SizeConfig.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: AppTextStyles.title28Black87Bold,
              ),
              Text(
                'Login to continue your journey',
                style: AppTextStyles.title16GreyW500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
