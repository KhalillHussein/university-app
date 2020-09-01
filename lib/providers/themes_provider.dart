import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/themes.dart';

class ThemesProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemesProvider(this._themeData);

  getTheme() => _themeData;

//  ThemeData get themeData {
//    if (_themeData == null) {
//      final isPlatformDark =
//          WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
//      _themeData = isPlatformDark ? darkTheme : lightTheme;
//    }
//    return _themeData;
//  }

//  setTheme(ThemeData themeData) {
//    _themeData = themeData;
//    //notifyListeners();
//  }

//    void init() {
//    SharedPreferences.getInstance().then((prefs) {
//      var darkModeOn = prefs.getBool('theme') ?? true;
//      _themeData = darkModeOn ? darkTheme : lightTheme;
//      notifyListeners();
//    });
//  }
//
  setTheme(bool value) async {
    print(value);
    _themeData = value ? darkTheme : lightTheme;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', value);
  }
}
