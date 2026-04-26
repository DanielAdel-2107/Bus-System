import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_system/features/settings/models/settings_model.dart';
import 'package:bus_system/features/settings/view_models/settings_cubit/settings_state.dart';
import 'package:bus_system/core/network/supabase/auth/sign_out_.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsInitial(SettingsModel())) {
    _loadSettings();
  }

  static const String _themeKey = 'is_dark_mode';
  static const String _langKey = 'language_code';
  static const String _notificationKey = 'is_notifications_enabled';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
    final langCode = prefs.getString(_langKey) ?? 'en';
    final isNotificationsEnabled = prefs.getBool(_notificationKey) ?? true;

    emit(SettingsUpdated(SettingsModel(
      isDarkMode: isDarkMode,
      languageCode: langCode,
      isNotificationsEnabled: isNotificationsEnabled,
    )));
  }

  Future<void> toggleNotifications(bool value) async {
    final updatedSettings = state.settings.copyWith(isNotificationsEnabled: value);
    emit(SettingsUpdated(updatedSettings));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, value);
  }

  Future<void> toggleDarkMode(bool value) async {
    final updatedSettings = state.settings.copyWith(isDarkMode: value);
    emit(SettingsUpdated(updatedSettings));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }

  Future<void> changeLanguage(String langCode) async {
    if (state.settings.languageCode == langCode) return;
    final updatedSettings = state.settings.copyWith(languageCode: langCode);
    emit(SettingsUpdated(updatedSettings));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  Future<void> logout() async {
    emit(SettingsLogoutLoading(state.settings));
    try {
      await SupabaseAuthService.signOut();
      emit(SettingsLogoutSuccess(state.settings));
    } catch (e) {
      emit(SettingsLogoutError(state.settings, 'Failed to log out. Please try again.'));
    }
  }
}
