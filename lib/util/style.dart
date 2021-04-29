import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

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
    accentColor: kLightPrimaryColor,
    appBarTheme: AppBarTheme(titleSpacing: 0.0),
    buttonTheme: ButtonThemeData(buttonColor: kLightPrimaryColor),
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
    textTheme: GoogleFonts.rubikTextTheme(ThemeData.light().textTheme),
  );

  /// Dark style
  static final ThemeData dark = ThemeData(
    accentColor: kDarkPrimaryColor,
    appBarTheme: AppBarTheme(titleSpacing: 0.0),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 3.0,
      selectedItemColor: kDarkSecondaryColor,
      type: BottomNavigationBarType.fixed,
    ),
    brightness: Brightness.dark,
    canvasColor: k08dp,
    cardColor: k02dp,
    dialogBackgroundColor: k24dp,
    dividerColor: Colors.white12,
    errorColor: kDarkErrorColor,
    primaryColor: k04dp,
    pageTransitionsTheme: _pageTransitionsTheme,
    scaffoldBackgroundColor: k01dp,
    selectedRowColor: Colors.white.withOpacity(0.2),
    textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
  );
}
