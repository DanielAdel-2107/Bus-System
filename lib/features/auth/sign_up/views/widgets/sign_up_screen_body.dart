import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/utilies/extensions/app_extensions.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/gradient_background.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/have_account_or_not.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_form.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_button.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_header.dart';

class SignUpScreenBody extends StatelessWidget {
  const SignUpScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.popScreen();
          CustomQuickAlert.success(
            title: 'Sign Up Successful',
            message: 'Your account has been created successfully.',
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
        if (state is SignUpFailure) {
          CustomQuickAlert.error(
            title: 'Sign Up Failed',
            message: state.errorMessage,
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
        if (state is AcceptTermsAndPolicy) {
          CustomQuickAlert.info(
            title: 'Terms and Conditions',
            message: 'Please accept the terms and conditions to continue.',
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
        if (state is PasswordDontMatch) {
          CustomQuickAlert.error(
            title: 'Password Dont Match',
            message: 'Please make sure your passwords match.',
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
        if (state is ImageRequired) {
          CustomQuickAlert.warning(
            title: 'Image Required',
            message: 'Please select a profile image to continue.',
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
      },
      child: Stack(
        children: [
          GradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.06),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: SizeConfig.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.height * 0.03),
                      SignUpHeader(),
                      SizedBox(height: SizeConfig.height * 0.03),
                      SignUpForm(),
                      SizedBox(height: SizeConfig.height * 0.03),
                      SignUpButton(),
                      SizedBox(height: SizeConfig.height * 0.0125),
                      HaveAcountOrNot(
                        title: 'Already have an account? ',
                        actionTitle: 'Sign In',
                        onTap: () {
                          context.popScreen();
                        },
                      ),
                      SizedBox(height: SizeConfig.height * 0.0125),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
