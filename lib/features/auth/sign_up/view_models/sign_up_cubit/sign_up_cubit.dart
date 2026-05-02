import 'package:bus_system/features/auth/sign_up/view_models/sign_up_cubit/sign_up_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SupabaseClient supabase;

  SignUpCubit(this.supabase) : super(const SignUpState());

  Future<void> signUpUser({
    required String role,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String gender,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      debugPrint('--- SIGN UP TRACKING START ---');
      
      User? user = supabase.auth.currentUser;

      // 1. Auth Logic: Handle new sign up or recovery
      if (user != null && user.email != email) {
        await supabase.auth.signOut();
        user = null;
      }

      if (user == null) {
        try {
          debugPrint('Step 1: Attempting Auth Sign Up...');
          final response = await supabase.auth.signUp(
            email: email,
            password: password,
            data: {
              'full_name': fullName,
              'phone': phone,
              'role': role,
            },
          );
          user = response.user;
          debugPrint('Step 1 SUCCESS (New User): ${user?.id}');
        } on AuthException catch (e) {
          // Recovery: If user already exists, try to sign in to finish the process
          if (e.message.toLowerCase().contains('already') || 
              e.message.toLowerCase().contains('taken') ||
              e.code == 'user_already_exists') {
            debugPrint('Step 1 RECOVERY: User exists, attempting Sign In...');
            try {
              final signInRes = await supabase.auth.signInWithPassword(
                email: email,
                password: password,
              );
              user = signInRes.user;
              debugPrint('Step 1 RECOVERY SUCCESS: ${user?.id}');
            } on AuthException catch (signInError) {
              // If sign in fails, then the email is taken by someone else (wrong password)
              throw Exception('This email is already registered. Please use a different email or login.');
            }
          } else {
            rethrow;
          }
        }
      }

      if (user == null) {
        throw Exception('User creation failed - No session acquired.');
      }

      // 2. Fetch FCM Token
      String? token;
      try {
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        debugPrint('Step 2 WARNING: FCM Token error: $e');
      }

      // 3. Create Profile (Upsert to handle recovery)
      debugPrint('Step 3: Syncing profile...');
      try {
        await supabase.from('profiles').upsert({
          'id': user.id,
          'full_name': fullName,
          'phone': phone,
          'role': role.toLowerCase(),
          'gender': gender.toLowerCase(),
          'tokens': token != null ? [token] : [],
        });
      } on PostgrestException catch (e) {
        if (e.message.toLowerCase().contains('phone') && e.message.toLowerCase().contains('unique')) {
           throw Exception('This phone number is already registered with another account.');
        }
        rethrow;
      }

      // 4. Role-specific additional logic
      if (role.toLowerCase() == 'student') {
        debugPrint('Step 4: Syncing student record...');
        await supabase.from('students').upsert({
          'id': user.id,
          'gender': gender.toLowerCase(),
        });
      }

      debugPrint('--- SIGN UP TRACKING END - SUCCESS ---');
      emit(state.copyWith(isLoading: false, user: user));
    } on AuthException catch (e) {
      debugPrint('--- SIGN UP TRACKING AUTH ERROR: ${e.message} ---');
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } on PostgrestException catch (e) {
      debugPrint('--- SIGN UP TRACKING DB ERROR: ${e.message} ---');
      emit(state.copyWith(isLoading: false, errorMessage: 'Database Error: ${e.message}'));
    } catch (e) {
      debugPrint('--- SIGN UP TRACKING UNEXPECTED ERROR: $e ---');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
