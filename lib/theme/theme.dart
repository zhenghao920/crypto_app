import 'package:crypto_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    accentColor: Colors.black,
    primarySwatch: createMaterialColor(gold),
    shadowColor: Colors.grey.shade300,
    scaffoldBackgroundColor: Color(0xfff1f1f1));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  //accentColor: Colors.white,
  primarySwatch: Colors.yellow,
  shadowColor: Colors.grey.shade800,
);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  ;
  return MaterialColor(color.value, swatch);
}

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
    if (prefs == null) {
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
