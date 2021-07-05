import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/index.dart';
import '../../util/index.dart';

class ThemeSwitchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final themesProvider = Provider.of<ThemesProvider>(context);
    bool isDarkTheme = themeProvider.brightness == Brightness.dark;
    Future.delayed(
      Duration(milliseconds: 200),
      () => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: isDarkTheme ? k08dp : Colors.grey[100],
        systemNavigationBarIconBrightness:
            themeProvider.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      )),
    );
    return ThemeSwitcher(
      builder: (context) => IconButton(
          splashRadius: 20,
          tooltip: 'Тема',
          icon: Icon(
            isDarkTheme ? MdiIcons.weatherSunny : MdiIcons.weatherNight,
          ),
          onPressed: () async {
            isDarkTheme = !isDarkTheme;
            await themesProvider.setTheme(isDarkTheme);
            ThemeSwitcher.of(context).changeTheme(
              theme: themeProvider.brightness == Brightness.light
                  ? Style.dark
                  : Style.light,
              reverseAnimation: themeProvider.brightness == Brightness.dark,
            );
          }),
    );
  }
}
