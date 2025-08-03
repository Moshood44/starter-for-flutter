import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  void setThemeMode(AppThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _saveThemeMode(mode);
      notifyListeners();
    }
  }

  void toggleTheme() {
    switch (_themeMode) {
      case AppThemeMode.light:
        setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        setThemeMode(AppThemeMode.system);
        break;
      case AppThemeMode.system:
        setThemeMode(AppThemeMode.light);
        break;
    }
  }

  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  String get themeModeString {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  IconData get themeModeIcon {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  // Load theme mode from storage (placeholder for now)
  Future<void> loadThemeMode() async {
    // TODO: Implement actual storage when SharedPreferences is added
    // For now, keep system default
    _themeMode = AppThemeMode.system;
    notifyListeners();
  }

  // Save theme mode to storage (placeholder for now)
  Future<void> _saveThemeMode(AppThemeMode mode) async {
    // TODO: Implement actual storage when SharedPreferences is added
    // For now, just provide haptic feedback
    HapticFeedback.selectionClick();
  }
}
