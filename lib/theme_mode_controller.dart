import 'package:flutter/material.dart';

/// In-memory theme choice. It lasts for the process only.
class ThemeModeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (_mode == mode) {
      return;
    }
    _mode = mode;
    notifyListeners();
  }
}
