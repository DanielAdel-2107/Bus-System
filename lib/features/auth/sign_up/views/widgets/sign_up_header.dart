import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.04,
          vertical: SizeConfig.height * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kPrimaryColor.withOpacity(0.4),
            AppColors.kSecondaryColor.withOpacity(0.3),
            AppColors.kPrimaryColor.withOpacity(0.2),
            AppColors.kSecondaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(SizeConfig.width * 0.06),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.3),
          width: SizeConfig.width * 0.004,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.2),
            blurRadius: SizeConfig.width * 0.038,
            offset: Offset(0, SizeConfig.height * 0.01),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'header_icon',
            child: Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.03),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.kPrimaryColor,
                    AppColors.kSecondaryColor,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimaryColor.withOpacity(0.3),
                    blurRadius: SizeConfig.width * 0.03,
                    offset: Offset(0, SizeConfig.height * 0.0075),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: SizeConfig.width * 0.07,
              ),
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.kPrimaryColor,
                      AppColors.kSecondaryColor
                    ],
                  ).createShader(bounds),
                  child: Text('Create Account',
                      style: AppTextStyles.title28WhiteColorW500),
                ),
                Text('Join us and start your adventure',
                    style: AppTextStyles.title14WhiteW600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
