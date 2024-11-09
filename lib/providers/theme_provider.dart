import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences prefs;
  // Theme mode (Light, Dark, System)
  ThemeMode _themeMode = ThemeMode.system;

  // Shared Preferences key to save theme mode
  static const String themeModeKey = "theme_mode";

  // Constructor: Loads the theme mode from cache when the provider is initialized
  ThemeProvider({required this.prefs}) {
    _loadThemeMode();
  }

  // Getter for theme mode
  ThemeMode getThemeMode() => _themeMode;

  // Method to switch theme mode and notify listeners
  void setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners(); // Notify widgets to rebuild with the new theme

    // Save the selected theme mode in SharedPreferences
    await prefs.setInt(themeModeKey, themeMode.index);
  }

  // Loads the theme mode from SharedPreferences
  void _loadThemeMode() async {
    int? themeIndex = prefs.getInt(themeModeKey);

    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    notifyListeners(); // Ensure listeners update the theme after loading
  }
}
