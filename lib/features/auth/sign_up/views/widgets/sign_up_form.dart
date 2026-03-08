import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/pick_user_image.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_form_fields.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.06,
          vertical: SizeConfig.height * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.width * 0.06),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            blurRadius: SizeConfig.width * 0.063,
            offset: Offset(0, SizeConfig.height * 0.015),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig.width * 0.03,
            offset: Offset(0, SizeConfig.height * 0.0075),
          ),
        ],
      ),
      child: Column(
        children: [
          PickUserImage(),
          SizedBox(height: SizeConfig.height * 0.025),
          SignUpFormFields(),
        ],
      ),
    );
  }
}

