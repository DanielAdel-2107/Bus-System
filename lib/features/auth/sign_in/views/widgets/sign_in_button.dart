import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/core/components/custom_circular_progress_indecator.dart';
import 'package:bus_system/core/components/custom_elevavted_button_with_title.dart';
import 'package:bus_system/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) =>
          current is SignInLoading || previous is SignInLoading,
      builder: (context, state) {
        return state is SignInLoading
            ? CustomCircularProgresIndecator()
            : CustomElevatedButtonWithIcon(
                title: 'Sign In',
                onPressed: () {
                  context.read<SignInCubit>().signIn();
                },
                icon: Icons.arrow_forward,
              );
      },
    );
  }
}
