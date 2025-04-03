import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners(); // Notify all listeners when the theme changes
  }
}
