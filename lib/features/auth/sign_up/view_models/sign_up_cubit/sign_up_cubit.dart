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
      debugPrint('Email: $email');
      debugPrint('Role: $role');
      debugPrint('FullName: $fullName');

      // 1. Sign up user in Supabase Auth
      debugPrint('Step 1: Calling supabase.auth.signUp...');
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'role': role,
        },
      );
      
      final user = response.user;
      if (user == null) {
        debugPrint('Step 1 FAILED: User is null');
        throw Exception('User creation failed - No user returned from Supabase');
      }
      debugPrint('Step 1 SUCCESS: User created with ID: ${user.id}');

      // 2. Fetch FCM Token
      debugPrint('Step 2: Fetching FCM Token...');
      String? token;
      try {
        token = await FirebaseMessaging.instance.getToken();
        debugPrint('Step 2 SUCCESS: Token fetched');
      } catch (e) {
        debugPrint('Step 2 WARNING: FCM Token fetching error: $e');
      }

      // 3. Create Profile
      debugPrint('Step 3: Upserting to profiles table...');
      try {
        await supabase.from('profiles').upsert({
          'id': user.id,
          'full_name': fullName,
          'phone': phone,
          'role': role,
          'gender': gender.toLowerCase(),
          'tokens': token != null ? [token] : [],
        });
        debugPrint('Step 3 SUCCESS');
      } on PostgrestException catch (e) {
         debugPrint('Step 3 FAILED: ${e.message}');
         throw Exception('Database Error (Profiles): ${e.message}');
      }

      // 4. Role-specific additional logic
      if (role == 'student') {
        debugPrint('Step 4: Upserting to students table...');
        try {
          await supabase.from('students').upsert({
            'id': user.id,
            'gender': gender.toLowerCase(),
          });
          debugPrint('Step 4 SUCCESS');
        } on PostgrestException catch (e) {
          debugPrint('Step 4 FAILED: ${e.message}');
          throw Exception('Database Error (Students): ${e.message}');
        }
      }

      debugPrint('--- SIGN UP TRACKING END - SUCCESS ---');
      emit(state.copyWith(isLoading: false, user: user));
    } on AuthException catch (e) {
      debugPrint('--- SIGN UP TRACKING END - AUTH ERROR ---');
      debugPrint('Auth Error Message: ${e.message}');
      debugPrint('Auth Error Status: ${e.message}');
      emit(state.copyWith(isLoading: false, errorMessage: 'Auth Error: ${e.message}'));
    } catch (e) {
      debugPrint('--- SIGN UP TRACKING END - UNEXPECTED ERROR ---');
      debugPrint('Error: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
