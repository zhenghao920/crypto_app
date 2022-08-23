import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  accentColor: Colors.black,
  primarySwatch: Colors.indigo,
  shadowColor: Colors.grey.shade300,
  scaffoldBackgroundColor: Color(0xfff1f1f1)
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  accentColor: Colors.white,
  primarySwatch: Colors.indigo,
  shadowColor: Colors.grey.shade800,
);

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? prefs;
  late bool _isDark;
  
  bool get darkTheme => _isDark;

  ThemeProvider() {
    _isDark = true;
    loadPref();
  }

  toggleTheme() {
    _isDark = !_isDark;
    saveToPref();
    notifyListeners();
  }

  initPref() async {
    if(prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  loadPref() async {
    await initPref();
    _isDark = prefs!.getBool(key) ?? true;
    notifyListeners();
  }

  saveToPref() async {
    await initPref();
    prefs!.setBool(key, _isDark);
  }
}