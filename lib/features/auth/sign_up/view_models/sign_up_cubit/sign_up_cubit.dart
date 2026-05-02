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
        throw Exception('User creation failed - Please check your connection');
      }
      debugPrint('Step 1 SUCCESS: User ID: ${user.id}');

      // 2. Fetch FCM Token
      String? token;
      try {
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        debugPrint('Step 2 WARNING: FCM Token error: $e');
      }

      // 3. Create Profile (Upsert to handle partial failure recovery)
      debugPrint('Step 3: Creating profile...');
      await supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        'phone': phone,
        'role': role,
        'gender': gender.toLowerCase(),
        'tokens': token != null ? [token] : [],
      });

      // 4. Role-specific additional logic
      if (role.toLowerCase() == 'student') {
        debugPrint('Step 4: Creating student record...');
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
      emit(state.copyWith(isLoading: false, errorMessage: 'Unexpected Error: ${e.toString()}'));
    }
  }
}
