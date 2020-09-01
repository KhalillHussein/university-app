import 'package:flutter/material.dart';

import '../util/colors.dart';

final lightTheme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kLightPrimaryColor,
    selectedItemColor: kAccentColor,
    unselectedItemColor: Colors.grey[600],
  ),
  cardTheme: CardTheme(color: kLightPrimaryColor),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColorLight: kAvatarColor,
  backgroundColor: kLightPrimaryColor,
  snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey[200]),
  primaryColor: kLightPrimaryColor,
  accentColor: kAccentThemeColor,
  disabledColor: Colors.grey[300],
  scaffoldBackgroundColor: kLightPrimaryColor,
  dividerColor: Colors.grey[400],
  selectedRowColor: Colors.black.withOpacity(0.08),
  focusColor: Colors.black,
  appBarTheme: AppBarTheme(
    color: kLightAppBarColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[900])),
  ),
  primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
        color: Colors.grey[700],
      ),
  accentTextTheme: TextTheme(
    button: TextStyle(color: kAccentThemeColor, height: 1.5),
  ),
  iconTheme: ThemeData.light().iconTheme.copyWith(color: Colors.grey[600]),
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
        bodyText2: TextStyle(color: Colors.grey[900]),
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        button: TextStyle(color: Colors.grey[400]),
        headline5: TextStyle(color: kLightPrimaryColor),
      ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey[700]),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kDarkPrimaryColor,
    selectedItemColor: kAccentColor,
    unselectedItemColor: Colors.grey[300],
  ),
  backgroundColor: kDarkAppBarColor,
  cardTheme: CardTheme(color: kDarkCardColor),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColorDark: kAvatarColor,
  accentColor: kAccentThemeColor,
  disabledColor: Color(0xFF2F2F2F),
  scaffoldBackgroundColor: Color(0xFF121212),
  selectedRowColor: Colors.white.withOpacity(0.2),
  canvasColor: Color(0xFF363636),
  primaryColor: kDarkPrimaryColor,
  dividerColor: Colors.grey[700],
  focusColor: Colors.grey[300],
  appBarTheme: AppBarTheme(
    color: kDarkAppBarColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    helperStyle: TextStyle(color: Colors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
  accentTextTheme: TextTheme(
    button: TextStyle(color: kAccentThemeColor, height: 1.5),
  ),
  primaryIconTheme: ThemeData.dark().primaryIconTheme.copyWith(
        color: Colors.white,
      ),
  iconTheme: ThemeData.dark().iconTheme.copyWith(color: Colors.grey[300]),
  textTheme: ThemeData.dark().textTheme.copyWith(
        bodyText1: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
        ),
        bodyText2: TextStyle(color: Colors.white),
        headline5: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.grey[600]),
      ),
);
