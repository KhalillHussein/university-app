import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../util/style.dart';

class ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final themesProvider = Provider.of<ThemesProvider>(context);
    bool isDarkTheme = themeProvider.brightness == Brightness.dark;
    return ThemeSwitcher(
      builder: (context) => IconButton(
          splashRadius: 20,
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
