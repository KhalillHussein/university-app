import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/style.dart';

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
