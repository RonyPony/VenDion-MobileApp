import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _themeModeKey = 'ui_theme_mode';
  static const _languageCodeKey = 'ui_language_code';

  Future<ThemeMode> getThemeMode() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final value = preferences.getString(_themeModeKey);
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == value,
        orElse: () => ThemeMode.light,
      );
    } catch (_) {
      return ThemeMode.light;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_themeModeKey, mode.name);
    } catch (_) {
      // Preference errors should not block the user from using the app.
    }
  }

  Future<String> getLanguageCode() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(_languageCodeKey) ?? 'es';
    } catch (_) {
      return 'es';
    }
  }

  Future<void> saveLanguageCode(String languageCode) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_languageCodeKey, languageCode);
    } catch (_) {
      // Preference errors should not block the user from using the app.
    }
  }
}
