import 'package:flutter/material.dart';

import '../../../repositories/preferences_repository.dart';

class ThemeController extends ChangeNotifier {
  final PreferencesRepository preferences;
  ThemeMode themeMode;

  ThemeController(this.preferences) : themeMode = preferences.themeMode;

  String get label {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    await preferences.saveThemeMode(mode);
  }
}
