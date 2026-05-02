import 'package:bus_system/core/app_route/route_names.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_up/view_models/sign_up_cubit/sign_up_cubit.dart';
import 'package:bus_system/features/auth/sign_up/view_models/sign_up_cubit/sign_up_state.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_form.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreenBody extends StatelessWidget {
  final String role;
  const SignUpScreenBody({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading || current.hasError || current.isSuccess,
      listener: (context, state) {
        // Handle Loading State
        if (state.isLoading) {
          CustomQuickAlert.loading(
            title: 'Please wait',
            message: 'Creating your account...',
          );
        } else {
          // Close loading dialog
          CustomQuickAlert.dismiss();
        }

        // Handle Success
        if (state.isSuccess) {
          if (role.toLowerCase() == 'student') {
            Navigator.pushReplacementNamed(context, RouteNames.studentRegisterScreen);
          } else if (role.toLowerCase() == 'driver') {
            Navigator.pushReplacementNamed(context, RouteNames.driverRegisterScreen);
          }

          Future.delayed(const Duration(milliseconds: 500), () {
            CustomQuickAlert.success(
              message: 'Account created successfully!',
              title: 'Success',
            );
          });
        }

        // Handle Error
        if (state.hasError && !state.isLoading) {
          CustomQuickAlert.error(
            message: state.errorMessage ?? 'Something went wrong',
            title: 'Error',
          );
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.06,
            vertical: SizeConfig.height * 0.04,
          ),
          child: Column(
            children: [
              const SignUpHeader(),
              SizedBox(height: SizeConfig.height * 0.04),
              SignUpForm(role: role),
              SizedBox(height: SizeConfig.height * 0.03),
              _buildLoginLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.poppins(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Login',
            style: GoogleFonts.poppins(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
