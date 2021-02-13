import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/index.dart';

class ThemesProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemesProvider(this._themeData);

  ThemeData getTheme() => _themeData;

  Future<void> setTheme(bool value) async {
    _themeData = value ? Style.dark : Style.light;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', value);
  }
}
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../util/index.dart';
//
// class ThemesProvider with ChangeNotifier {
//   ThemeData _themeData;
//
//   ThemesProvider() {
//     init();
//   }
//
//   ThemeData getTheme() => _themeData;
//
//   Future<void> setTheme(bool value) async {
//     _themeData = value ? Style.dark : Style.light;
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('theme', value);
//   }
//
//   /// Load theme information from local storage
//   Future<void> init() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final bool darkModeOn = prefs.getBool('theme') ?? false;
//     _themeData = darkModeOn ? Style.dark : Style.light;
//     notifyListeners();
//   }
// }
