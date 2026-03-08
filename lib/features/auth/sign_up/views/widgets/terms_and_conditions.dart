
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (previous, current) =>
              current is ChangeTermsAndPolicy ||
              previous is ChangeTermsAndPolicy,
          builder: (context, state) {
            return Checkbox(
              value: context.read<SignUpCubit>().acceptTerms,
              onChanged: (value) {
                context.read<SignUpCubit>().toggleTermsAndPolicy();
              },
              activeColor: AppColors.kPrimaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          },
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: getResponsiveFontSize(fontSize: 16),
              ),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
