import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/components/custom_circular_progress_indecator.dart';
import 'package:bus_system/core/components/custom_elevavted_button_with_title.dart';
import 'package:bus_system/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous is SignUpLoading || current is SignUpLoading,
      builder: (context, state) {
        return state is SignUpLoading
            ? CustomCircularProgresIndecator()
            : CustomElevatedButtonWithIcon(
                title: 'Sign Up',
                onPressed: () {
                  context.read<SignUpCubit>().signUp();
                },
                icon: Icons.arrow_forward,
              );
      },
    );
  }
}
