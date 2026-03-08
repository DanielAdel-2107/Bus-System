import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/app_route/route_names.dart';
import 'package:bus_system/core/utilies/extensions/app_extensions.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:bus_system/features/auth/sign_in/views/widgets/sign_in_button.dart';
import 'package:bus_system/features/auth/sign_in/views/widgets/sign_in_form.dart';
import 'package:bus_system/features/auth/sign_in/views/widgets/sign_in_header.dart';
import 'package:bus_system/features/auth/sign_in/views/widgets/wave_lottie.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/gradient_background.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/have_account_or_not.dart';

class SignInScreenBody extends StatelessWidget {
  const SignInScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          CustomQuickAlert.success(
            title: 'Success',
            message: 'You have signed in successfully!',
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
        if (state is SignInFailure) {
          CustomQuickAlert.error(
            title: 'Error',
            message: state.message,
            animationType: CustomQuickAlertAnimationType.slideInDown,
          );
        }
      },
      child: Stack(
        children: [
          GradientBackground(),
          WaveLottie(),
          SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),
                  SignInHeader(),
                  SizedBox(height: SizeConfig.height * 0.05),
                  SignInForm(),
                  SizedBox(height: SizeConfig.height * 0.04),
                  SignInButton(),
                  SizedBox(height: SizeConfig.height * 0.03),
                  HaveAcountOrNot(
                    title: 'Don\'t have an account? ',
                    actionTitle: 'Create new account',
                    onTap: () {
                      context.pushScreen(RouteNames.signUpScreen);
                    },
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
