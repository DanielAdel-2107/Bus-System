class SettingsModel {
  final bool isNotificationsEnabled;
  final bool isDarkMode;
  final String languageCode;

  const SettingsModel({
    this.isNotificationsEnabled = true,
    this.isDarkMode = false,
    this.languageCode = 'en',
  });

  SettingsModel copyWith({
    bool? isNotificationsEnabled,
    bool? isDarkMode,
    String? languageCode,
  }) {
    return SettingsModel(
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
