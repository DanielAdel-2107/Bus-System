import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/components/custom_text_form_field_with_title.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/terms_and_conditions.dart';

class SignUpFormFields extends StatelessWidget {
  const SignUpFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignUpCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          CustomTextFormFieldWithTitle(
            labelText: "Full Name",
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            controller: cubit.nameController,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          CustomTextFormFieldWithTitle(
            labelText: "Email Address",
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            controller: cubit.emailController,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          CustomTextFormFieldWithTitle(
            labelText: "Phone Number",
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            controller: cubit.phoneController,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          CustomTextFormFieldWithTitle(
            labelText: "Password",
            prefixIcon: Icons.lock_outlined,
            isPassword: true,
            controller: cubit.passwordController,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          CustomTextFormFieldWithTitle(
            labelText: "Confirm Password",
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            controller: cubit.confirmPasswordController,
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          TermsAndConditions(),
        ],
      ),
    );
  }
}

