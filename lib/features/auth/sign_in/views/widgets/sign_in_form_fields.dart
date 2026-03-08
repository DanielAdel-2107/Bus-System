import 'package:flutter/material.dart';
import 'package:bus_system/core/components/custom_text_form_field_with_title.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';

class SignInFormFields extends StatelessWidget {
  const SignInFormFields({
    super.key,
    required this.cubit,
  });

  final SignInCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormFieldWithTitle(
            labelText: 'Email Address',
            prefixIcon: Icons.email_outlined,
            controller: cubit.emailController),
        SizedBox(height: SizeConfig.height * 0.02),
        CustomTextFormFieldWithTitle(
          labelText: 'Password',
          prefixIcon: Icons.lock_outlined,
          controller: cubit.passwordController,
          isPassword: true,
        ),
      ],
    );
  }
}
