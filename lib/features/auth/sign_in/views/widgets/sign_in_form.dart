import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/components/custom_text_button.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:bus_system/features/auth/sign_in/views/widgets/sign_in_form_fields.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignInCubit>();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.04,
        vertical: SizeConfig.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.width * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig.width * 0.05,
            offset: Offset(0, SizeConfig.height * 0.0125),
          ),
        ],
      ),
      child: Form(
        key: cubit.formKey,
        child: Column(
          children: [
            SignInFormFields(cubit: cubit),
            SizedBox(height: SizeConfig.height * 0.01),
            CustomTextButton(
              onPressed: () {},
              alignment: Alignment.centerRight,
              title: 'Forgot Password?',
            ),
          ],
        ),
      ),
    );
  }
}

