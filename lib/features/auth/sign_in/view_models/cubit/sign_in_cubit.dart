import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      
      final userId = getIt<SupabaseClient>().auth.currentUser!.id;
      
      // Fetch user profile to get role
      final response = await getIt<SupabaseClient>()
          .from("profiles")
          .select()
          .eq("id", userId)
          .single();

      if (response.isNotEmpty) {
        final userModel = UserModel.fromJson(response);
        await getIt<CacheHelper>().saveUserModel(userModel);
        await _updateDeviceToken(userId);
        emit(SignInSuccess(role: userModel.role ?? ''));
      } else {
        throw Exception("Error in get user data");
      }
    } catch (e) {
      emit(SignInFailure(message: e.toString()));
    }
  }

  Future<void> _updateDeviceToken(String userId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      final supabase = getIt<SupabaseClient>();
      
      // Fetch current tokens
      final response = await supabase
          .from('profiles')
          .select('tokens')
          .eq('id', userId)
          .single();
      
      List<String> tokens = List<String>.from(response['tokens'] ?? []);
      
      if (!tokens.contains(token)) {
        tokens.add(token);
        await supabase
            .from('profiles')
            .update({'tokens': tokens})
            .eq('id', userId);
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  saveUserData() async {
    try {
      final response = await getIt<SupabaseClient>()
          .from("profiles") // Changed from "users" to "profiles" to match our schema
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
