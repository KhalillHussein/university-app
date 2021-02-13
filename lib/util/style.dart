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
    accentColor: kAccentThemeColor,
    accentIconTheme: IconThemeData(color: Colors.grey[300]),
    accentTextTheme: TextTheme(
      button: const TextStyle(color: kAccentThemeColor, height: 1.5),
    ),
    appBarTheme: AppBarTheme(brightness: Brightness.light),
    backgroundColor: kLightPrimaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kLightPrimaryColor,
      elevation: 1.5,
      selectedItemColor: kAccentColor,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardTheme(color: kLightPrimaryColor, elevation: 1),
    cardColor: kLightAltLightColor,
    dividerColor: Colors.grey[400],
    disabledColor: Colors.grey[300],
    dialogTheme: DialogTheme(
      backgroundColor: kLightPrimaryColor,
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 14),
    ),
    focusColor: Colors.black,
    highlightColor: Colors.grey.withOpacity(0.2),
    iconTheme: IconThemeData(color: Colors.black),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[900]),
      ),
    ),
    primaryColorLight: kAvatarColor,
    primaryColor: kLightPrimaryColor,
    pageTransitionsTheme: _pageTransitionsTheme,
    primaryIconTheme: IconThemeData(color: Colors.grey[700]),
    scaffoldBackgroundColor: kLightScaffoldBgColor,
    selectedRowColor: Colors.black.withOpacity(0.08),
    snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey[200]),
    splashColor: Colors.white30,
    textTheme: ThemeData.light().textTheme.copyWith(
          button: TextStyle(color: Colors.grey[400]),
          bodyText1: TextStyle(
            fontSize: 16,
            height: 1.7,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.black,
          ),
          headline5: TextStyle(fontWeight: FontWeight.bold),
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          caption:
              TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// Dark style
  static final ThemeData dark = ThemeData(
    accentColor: kAccentThemeColor,
    accentIconTheme: IconThemeData(color: Colors.grey[700]),
    accentTextTheme: TextTheme(
      button: TextStyle(color: kAccentThemeColor, height: 1.5),
    ),
    appBarTheme: AppBarTheme(
      color: kDarkAltColor,
      brightness: Brightness.dark,
    ),
    backgroundColor: kDarkAltColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kDarkPrimaryColor,
      elevation: 1.5,
      selectedItemColor: kAccentColor,
      unselectedItemColor: Colors.grey[300],
      type: BottomNavigationBarType.fixed,
    ),
    brightness: Brightness.dark,
    canvasColor: Color(0xFF363636),
    cardTheme: CardTheme(color: kDarkCardColor, elevation: 1),
    cardColor: kDarkAltColor,
    dialogTheme: DialogTheme(
      backgroundColor: kDarkPrimaryColor,
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.grey[400], fontSize: 14),
    ),
    disabledColor: Color(0xFF2F2F2F),
    dividerColor: Colors.grey[700],
    focusColor: Colors.grey[300],
    highlightColor: Colors.grey[700],
    iconTheme: IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      helperStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    pageTransitionsTheme: _pageTransitionsTheme,
    primarySwatch: Colors.blue,
    primaryColorDark: kAvatarColor,
    primaryColor: kDarkPrimaryColor,
    primaryIconTheme: IconThemeData(color: Colors.white),
    scaffoldBackgroundColor: kDarkScaffoldBgColor,
    selectedRowColor: Colors.white.withOpacity(0.2),
    snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey[800]),
    splashColor: Colors.grey[900].withOpacity(0.4),
    textTheme: ThemeData.dark().textTheme.copyWith(
          button: TextStyle(color: Colors.grey[600]),
          bodyText1: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.white,
          ),
          headline5:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
