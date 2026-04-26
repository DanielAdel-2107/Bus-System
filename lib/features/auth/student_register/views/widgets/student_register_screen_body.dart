import 'package:bus_system/core/components/custom_loading_widget.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/student_register/view_models/cubit/student_register_cubit.dart';
import 'package:bus_system/features/auth/student_register/view_models/cubit/student_register_state.dart';
import 'package:bus_system/features/auth/student_register/views/widgets/student_register_button.dart';
import 'package:bus_system/features/auth/student_register/views/widgets/student_register_form.dart';
import 'package:bus_system/features/auth/student_register/views/widgets/student_register_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bus_system/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegisterScreenBody extends StatelessWidget {
  const StudentRegisterScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentRegisterCubit, StudentRegisterState>(
      listener: (context, state) {
        if (state is StudentRegisterSuccess) {
          CustomQuickAlert.success(
            message: 'Your profile has been completed! 🎓',
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
            }
          });
        } else if (state is StudentRegisterFailure) {
          CustomQuickAlert.error(message: state.errorMessage);
        }
      },
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
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: AppColors.primaryBlue,
                ).animate().fadeIn().slideX(begin: -0.2),

                const StudentRegisterHeader(),

                SizedBox(height: SizeConfig.height * 0.04),

                // Premium Card Layout
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
                  child: const StudentRegisterForm(),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                SizedBox(height: SizeConfig.height * 0.06),

                // Submit Button
                Center(
                  child: BlocBuilder<StudentRegisterCubit, StudentRegisterState>(
                    builder: (context, state) {
                      if (state is StudentRegisterLoading) {
                        return const CustomLoadingWidget();
                      }
                      return StudentRegisterButton(
                        onPressed: () {
                          context.read<StudentRegisterCubit>().submitStudentInfo();
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
    );
  }
}
