import 'package:bus_system/core/components/custom_drop_down_button_form_field.dart';
import 'package:bus_system/core/components/custom_text_form_field_with_title.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/student_register/view_models/cubit/student_register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegisterForm extends StatelessWidget {
  const StudentRegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentRegisterCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          CustomTextFormFieldWithTitle(
            title: 'College / Faculty',
            hintText: 'e.g. Faculty of Engineering',
            controller: cubit.facultyController,
            prefixIcon: Icons.account_balance_rounded,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),

          SizedBox(height: SizeConfig.height * 0.02),

          CustomTextFormFieldWithTitle(
            title: 'University Year (Level)',
            hintText: 'e.g. 1, 2, 3, 4',
            controller: cubit.levelController,
            prefixIcon: Icons.school_rounded,
            keyboardType: TextInputType.number,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

          SizedBox(height: SizeConfig.height * 0.02),

          CustomDropDownButtonFormField<String>(
            title: 'Gender',
            hintText: 'Select your gender',
            items: const ['Male', 'Female'],
            value: cubit.selectedGender,
            onChanged: (val) => cubit.selectGender(val),
            primaryColor: AppColors.primaryBlue,
            itemLabelBuilder: (item) => item,
          ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),

          SizedBox(height: SizeConfig.height * 0.02),

          CustomTextFormFieldWithTitle(
            title: 'Phone Number',
            hintText: 'e.g. +20 123 456 7890',
            controller: cubit.phoneController,
            prefixIcon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            primaryColor: AppColors.primaryBlue,
          ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
        ],
      ),
    );
  }
}
