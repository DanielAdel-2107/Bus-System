import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:bus_system/core/cache/cache_helper.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/network/supabase/auth/sign_in_with_password.dart';
import 'package:bus_system/features/auth/sign_up/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  // var
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // functions
  signIn() async {
    try {
      emit(SignInLoading());
      await signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await saveUserData();
      emit(SignInSuccess());
    } catch (e) {
      emit(SignInFailure(message: e.toString()));
    }
  }

  saveUserData() async {
    try {
      final response = await getIt<SupabaseClient>()
          .from("users")
          .select()
          .eq("id", getIt<SupabaseClient>().auth.currentUser!.id)
          .single();
      if (response.isNotEmpty) {
        await getIt<CacheHelper>().saveUserModel(UserModel.fromJson(response));
      } else {
        throw Exception("Error in get user data");
      }
    } on Exception catch (e) {
      emit(SignInFailure(message: e.toString()));
    }
  }
}
