import 'package:bus_system/core/app_route/route_names.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/driver_register/views/widgets/register_button.dart';
import 'package:bus_system/features/auth/driver_register/views/widgets/register_form.dart';
import 'package:bus_system/features/auth/driver_register/views/widgets/register_header.dart';
import 'package:bus_system/features/auth/driver_register/view_models/cubit/driver_register_cubit.dart';
import 'package:bus_system/features/auth/driver_register/view_models/cubit/driver_register_state.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverRegisterScreenBody extends StatelessWidget {
  const DriverRegisterScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverRegisterCubit, DriverRegisterState>(
      listener: (context, state) {
        if (state is DriverRegisterSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.signInScreen,
            (route) => false,
          );

          CustomQuickAlert.success(
            message:
                'Your application has been submitted successfully! Please sign in again while we verify your account.',
            title: 'Submitted!',
          );
        } else if (state is DriverRegisterFailure) {
          CustomQuickAlert.error(
            message: state.errorMessage,
            title: 'Submission Error',
            onConfirm: () {
              // Optionally allow them to go back to Sign In if they are stuck
              if (state.errorMessage.contains('session') ||
                  state.errorMessage.contains('already registered')) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.signInScreen,
                  (route) => false,
                );
              }
            },
          );
        }
      },
      child: PopScope(
        // Prevent the driver from pressing the system back button to skip
        canPop: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: AppColors.background),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.06,
                vertical: SizeConfig.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // No back button — driver must complete this step
                  const RegisterHeader(),

                  SizedBox(height: SizeConfig.height * 0.04),
                  Container(
                    padding: EdgeInsets.all(SizeConfig.width * 0.05),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      gradient: AppColors.cardGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: const RegisterForm(),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                  SizedBox(height: SizeConfig.height * 0.06),

                  // Submit Button
                  Center(
                    child:
                        BlocBuilder<DriverRegisterCubit, DriverRegisterState>(
                          builder: (context, state) {
                            if (state is DriverRegisterLoading) {
                              return const CircularProgressIndicator(
                                color: AppColors.primaryBlue,
                              );
                            }
                            return RegisterButton(
                              onPressed: () {
                                context
                                    .read<DriverRegisterCubit>()
                                    .submitDriverInfo();
                              },
                            );
                          },
                        ),
                  ),

                  SizedBox(height: SizeConfig.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
