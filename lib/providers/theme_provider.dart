import 'package:flutter/material.dart';
import '../services/storage_service.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get currentThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Initialize theme from storage
  Future<void> initialize() async {
    final savedTheme = StorageService.getThemeMode();
    
    switch (savedTheme) {
      case 'light':
        _themeMode = AppThemeMode.light;
        break;
      case 'dark':
        _themeMode = AppThemeMode.dark;
        break;
      default:
        _themeMode = AppThemeMode.system;
    }
    
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    
    String modeString;
    switch (mode) {
      case AppThemeMode.light:
        modeString = 'light';
        break;
      case AppThemeMode.dark:
        modeString = 'dark';
        break;
      case AppThemeMode.system:
        modeString = 'system';
        break;
    }
    
    await StorageService.saveThemeMode(modeString);
    notifyListeners();
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    if (_themeMode == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }
}
