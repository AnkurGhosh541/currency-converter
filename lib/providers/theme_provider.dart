import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;

  get currentTheme => _currentTheme;

  void changeTheme() {
    if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
    } else {
      _currentTheme = ThemeMode.light;
    }
    notifyListeners();
  }
}
