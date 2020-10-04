import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../util/style.dart';

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _ignoreOnPress = true;
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    _isDarkTheme = ThemeProvider.of(context).brightness == Brightness.dark;
    final themeData = Provider.of<ThemesProvider>(context, listen: false);
    return ThemeSwitcher(
      builder: (context) => IconButton(
        icon: Icon(
          _isDarkTheme
              ? CommunityMaterialIcons.weather_sunny
              : CommunityMaterialIcons.weather_night,
        ),
        onPressed: _ignoreOnPress
            ? () {
                _ignoreOnPress = false;
                Timer(
                  const Duration(milliseconds: 400),
                  () => setState(
                    () => _ignoreOnPress = true,
                  ),
                );
                _isDarkTheme = !_isDarkTheme;
                themeData.setTheme(_isDarkTheme);
                ThemeSwitcher.of(context).changeTheme(
                  theme:
                      ThemeProvider.of(context).brightness == Brightness.light
                          ? Style.dark
                          : Style.light,
                );
              }
            : () {},
      ),
    );
  }
}
