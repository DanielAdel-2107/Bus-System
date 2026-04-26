import 'package:bus_system/core/cache/cache_helper.dart';
import 'package:bus_system/core/di/dependancy_injection.dart';
import 'package:bus_system/core/network/supabase/auth/sign_out_.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bus_system/features/profile/models/profile_model.dart';
import 'package:bus_system/features/profile/view_models/profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileModel? _currentProfile;

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(const ProfileError('User is not authenticated.'));
        return;
      }
      
      final response = await Supabase.instance.client
          .from('profiles')
          .select('id, full_name, phone, role')
          .eq('id', user.id)
          .single();
          
      _currentProfile = ProfileModel(
        id: response['id'] as String,
        name: response['full_name'] as String? ?? 'No Name',
        phone: response['phone'] as String? ?? '',
        role: response['role'] as String? ?? 'user',
        imageUrl: '', // You can add avatar fetching logic here later
      );
      emit(ProfileLoaded(_currentProfile!));
    } catch (e) {
      emit(const ProfileError('Failed to load profile. Please try again.'));
    }
  }

  void toggleEditMode() {
    if (_currentProfile != null) {
      if (state is ProfileEditMode) {
        emit(ProfileLoaded(_currentProfile!));
      } else {
        emit(ProfileEditMode(_currentProfile!));
      }
    }
  }

  Future<void> updateProfile({required String newName, required String newPhone}) async {
    if (_currentProfile == null) return;
    
    emit(ProfileUpdating());

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      await Supabase.instance.client
          .from('profiles')
          .update({
            'full_name': newName,
            'phone': newPhone.isEmpty ? null : newPhone,
          })
          .eq('id', user.id);

      _currentProfile = _currentProfile!.copyWith(name: newName, phone: newPhone);
      emit(ProfileUpdateSuccess(_currentProfile!));
      emit(ProfileLoaded(_currentProfile!));
    } catch (e) {
      emit(const ProfileUpdateError('Something went wrong while updating your profile.'));
      emit(ProfileEditMode(_currentProfile!));
    }
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoading());
    try {
      await SupabaseAuthService.signOut().timeout(const Duration(seconds: 5));
      await getIt<CacheHelper>().clearData();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      // Even on failure, clear local cache and allow redirection
      await getIt<CacheHelper>().clearData();
      emit(ProfileLogoutSuccess());
    }
  }
}
