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
    accentColor: kSecondaryThemeColor,
    accentIconTheme: IconThemeData(color: Colors.grey[300]),
    accentTextTheme: TextTheme(
      button: const TextStyle(color: kSecondaryThemeColor, height: 1.5),
    ),
    appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        brightness: Brightness.light),
    backgroundColor: kLightPrimaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kLightPrimaryColor,
      elevation: 1.5,
      selectedItemColor: kLightAccentColor,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
    ),
    brightness: Brightness.light,
    cardTheme: CardTheme(color: kLightPrimaryColor, elevation: 3),
    cardColor: kLightPrimaryColor,
    dividerColor: Colors.grey[300],
    disabledColor: Colors.grey[300],
    dialogTheme: DialogTheme(
      backgroundColor: kLightPrimaryColor,
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 14),
    ),
    errorColor: kLightErrorColor,
    focusColor: Colors.black,
    highlightColor: Colors.grey.withOpacity(0.2),
    iconTheme: IconThemeData(color: Colors.black),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[900]),
      ),
    ),
    primaryColorLight: k24dp,
    primaryColor: kLightPrimaryColor,
    pageTransitionsTheme: _pageTransitionsTheme,
    primaryIconTheme: IconThemeData(color: Colors.grey[700]),
    scaffoldBackgroundColor: kLightPrimaryColor,
    selectedRowColor: Colors.black.withOpacity(0.08),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kLightPrimaryColor,
      contentTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
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
            fontWeight: FontWeight.w500,
          ),
          caption:
              TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// Dark style
  static final ThemeData dark = ThemeData(
    accentColor: kSecondaryThemeColor,
    accentIconTheme: IconThemeData(color: Colors.grey[700]),
    accentTextTheme: TextTheme(
      button: TextStyle(color: kSecondaryThemeColor, height: 1.5),
    ),
    appBarTheme: AppBarTheme(
      color: k02dp,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      brightness: Brightness.dark,
    ),
    backgroundColor: k02dp,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: k03dp,
      selectedItemColor: kDarkAccentColor,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
    ),
    brightness: Brightness.dark,
    canvasColor: Color(0xFF363636),
    cardTheme: CardTheme(color: k01dp, elevation: 3),
    cardColor: k02dp,
    dialogTheme: DialogTheme(
      backgroundColor: k03dp,
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.grey[400], fontSize: 14),
    ),
    disabledColor: Color(0xFF2F2F2F),
    dividerColor: Colors.grey[800],
    errorColor: kDarkErrorColor,
    focusColor: Colors.grey[300],
    highlightColor: Colors.grey[700],
    iconTheme: IconThemeData(color: Colors.white.withOpacity(0.87)),
    inputDecorationTheme: InputDecorationTheme(
      helperStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    pageTransitionsTheme: _pageTransitionsTheme,
    primarySwatch: Colors.blue,
    primaryColorDark: k24dp,
    primaryColor: k03dp,
    primaryIconTheme: IconThemeData(color: Colors.white),
    scaffoldBackgroundColor: k00dp,
    selectedRowColor: Colors.white.withOpacity(0.2),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[600],
      contentTextStyle: TextStyle(
        color: k00dp,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    splashColor: Colors.grey[900].withOpacity(0.4),
    textTheme: ThemeData.dark().textTheme.copyWith(
          button: TextStyle(color: Colors.grey[600]),
          bodyText1: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.white54.withOpacity(0.87),
          ),
          headline6: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontWeight: FontWeight.w500,
          ),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
