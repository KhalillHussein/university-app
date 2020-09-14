import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/style.dart';

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

  // Future<void> init() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     bool darkModeOn = prefs.getBool('theme') ?? true;
  //     _themeData = darkModeOn ? darkTheme : lightTheme;
  //   } catch (e) {
  //     prefs.setBool('theme', darkModeOn);
  //   }
  //   notifyListeners();
  // }

  setTheme(bool value) async {
    _themeData = value ? Style.st.dark : Style.st.light;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', value);
  }
}

// const Themes _defaultTheme = Themes.system;
//
// enum Themes { light, dark, system }
//
// final Map<Themes, ThemeData> _themeData = {
//   Themes.light: Style.st.light,
//   Themes.dark: Style.st.dark,
// };
//
// class ThemeProvider with ChangeNotifier {
//   static Themes _theme = _defaultTheme;
//
//   ThemeProvider() {
//     init();
//   }
//
//   Themes get theme => _theme;
//
//   set theme(Themes theme) {
//     _theme = theme;
//     notifyListeners();
//   }
//
//   /// Returns appropiate theme mode
//   ThemeMode get themeMode {
//     switch (_theme) {
//       case Themes.light:
//         return ThemeMode.light;
//       case Themes.dark:
//         return ThemeMode.dark;
//       default:
//         return ThemeMode.system;
//     }
//   }
//
//   /// Default light theme
//   ThemeData get lightTheme => _themeData[Themes.light];
//
//   /// Default dark theme
//   ThemeData get darkTheme => _themeData[Themes.dark];
//
//   /// Load theme information from local storage
//   Future<void> init() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     try {
//       theme = Themes.values[prefs.getInt('theme')];
//     } catch (e) {
//       prefs.setInt('theme', Themes.values.indexOf(_defaultTheme));
//     }
//
//     notifyListeners();
//   }
// }
