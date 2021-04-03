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
    accentColor: kLightPrimaryColor,
    appBarTheme: AppBarTheme(
      titleSpacing: 0.0,
      backgroundColor: kLightColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    backgroundColor: kLightColor,
    buttonTheme: ButtonThemeData(buttonColor: kLightPrimaryColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kLightColor,
      selectedItemColor: kLightSecondaryColor,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
    ),
    disabledColor: Colors.grey[300],
    dividerColor: Colors.black12,
    errorColor: kLightErrorColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kLightSecondaryColor,
    ),
    iconTheme: IconThemeData(color: Colors.black54),
    pageTransitionsTheme: _pageTransitionsTheme,
    primaryColor: kLightPrimaryColor,
    primaryIconTheme: IconThemeData(color: Colors.black87),
    scaffoldBackgroundColor: kLightColor,
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        fontSize: 16,
      ),
    ),
    splashColor: Colors.white30,
    tabBarTheme: TabBarTheme(
      labelColor: kLightPrimaryColor,
      unselectedLabelColor: Colors.black54,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          button: TextStyle(color: Colors.grey[400]),
          bodyText1: TextStyle(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          bodyText2: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.black,
          ),
          // headline5: TextStyle(fontWeight: FontWeight.bold),
          headline6: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.w400,
          ),
          caption:
              TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
  );

  /// Dark style
  static final ThemeData dark = ThemeData(
    accentColor: kDarkPrimaryColor,
    appBarTheme: AppBarTheme(
      color: k04dp,
      titleSpacing: 0.0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    backgroundColor: k00dp,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: k08dp,
      selectedItemColor: kDarkSecondaryColor,
      unselectedItemColor: Colors.white60,
      type: BottomNavigationBarType.fixed,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: k08dp,
    ),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white60,
      labelColor: kDarkPrimaryColor,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    brightness: Brightness.dark,
    cardTheme: CardTheme(color: k01dp),
    cardColor: k02dp,
    dialogTheme: DialogTheme(
      backgroundColor: k24dp,
    ),
    disabledColor: Color(0xFF2F2F2F),
    dividerColor: Colors.white12,
    errorColor: kDarkErrorColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kDarkSecondaryColor,
      foregroundColor: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
    primaryColor: kDarkPrimaryColor,
    pageTransitionsTheme: _pageTransitionsTheme,
    primaryIconTheme: IconThemeData(color: Colors.white),
    scaffoldBackgroundColor: k00dp,
    selectedRowColor: Colors.white.withOpacity(0.2),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        color: k03dp,
        fontSize: 16,
      ),
    ),
    splashColor: Colors.grey[900].withOpacity(0.4),
    textTheme: ThemeData.dark().textTheme.copyWith(
          button: TextStyle(color: Colors.grey[600]),
          bodyText1: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
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
          subtitle1: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
