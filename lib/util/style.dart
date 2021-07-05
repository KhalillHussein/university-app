import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

/// Class that contains all the different styles of an app
class Style {
  /// Custom page transitions
  static final _pageTransitionsTheme = PageTransitionsTheme(
    builders: const {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  /// Light style
  static final ThemeData light = ThemeData(
    accentColor: kLightAccentColor,
    appBarTheme: AppBarTheme(titleSpacing: 0.0),
    buttonTheme: ButtonThemeData(buttonColor: kLightAccentColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 8.0,
      selectedItemColor: kLightSecondaryColor,
      type: BottomNavigationBarType.fixed,
    ),
    brightness: Brightness.light,
    errorColor: kLightErrorColor,
    pageTransitionsTheme: _pageTransitionsTheme,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: kLightColor,
    // textTheme: GoogleFonts.rubikTextTheme(ThemeData.light().textTheme),
  );

  /// Dark style
  static final ThemeData dark = ThemeData(
    accentColor: kDarkAccentColor,
    appBarTheme: AppBarTheme(titleSpacing: 0.0),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 3.0,
      selectedItemColor: kDarkSecondaryColor,
      type: BottomNavigationBarType.fixed,
    ),
    bottomAppBarColor: k06dp,
    brightness: Brightness.dark,
    canvasColor: k08dp,
    cardColor: k04dp,
    dialogBackgroundColor: k24dp,
    dividerColor: Colors.white12,
    errorColor: kDarkErrorColor,
    primaryColor: k06dp,
    pageTransitionsTheme: _pageTransitionsTheme,
    scaffoldBackgroundColor: k01dp,
    selectedRowColor: Colors.white.withOpacity(0.2),
    // textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
  );
}
