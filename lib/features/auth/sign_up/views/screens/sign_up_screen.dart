import 'package:bus_system/features/auth/sign_up/view_models/sign_up_cubit/sign_up_cubit.dart';
import 'package:bus_system/features/auth/sign_up/views/widgets/sign_up_screen_body.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatelessWidget {
  final String role;

  const SignUpScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(Supabase.instance.client),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SignUpScreenBody(role: role),
      ),
    );
  }
}
