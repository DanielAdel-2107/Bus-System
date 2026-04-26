import 'package:bus_system/features/settings/models/settings_model.dart';

abstract class SettingsState {
  final SettingsModel settings;
  const SettingsState(this.settings);
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(super.settings);
}

class SettingsUpdated extends SettingsState {
  const SettingsUpdated(super.settings);
}

class SettingsLogoutLoading extends SettingsState {
  const SettingsLogoutLoading(super.settings);
}

class SettingsLogoutSuccess extends SettingsState {
  const SettingsLogoutSuccess(super.settings);
}

class SettingsLogoutError extends SettingsState {
  final String message;
  const SettingsLogoutError(super.settings, this.message);
}
