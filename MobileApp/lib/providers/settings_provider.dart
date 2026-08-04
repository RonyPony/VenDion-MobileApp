import 'package:flutter/material.dart';
import 'package:vendion/services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._settingsService);

  final SettingsService _settingsService;

  ThemeMode _themeMode = ThemeMode.light;
  String _languageCode = 'es';
  bool _isLoaded = false;

  ThemeMode get themeMode => _themeMode;
  String get languageCode => _languageCode;
  bool get isLoaded => _isLoaded;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.getThemeMode();
    _languageCode = await _settingsService.getLanguageCode();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    notifyListeners();
    await _settingsService.saveThemeMode(mode);
  }

  Future<void> updateLanguageCode(String languageCode) async {
    if (_languageCode == languageCode) {
      return;
    }

    _languageCode = languageCode;
    notifyListeners();
    await _settingsService.saveLanguageCode(languageCode);
  }
}
