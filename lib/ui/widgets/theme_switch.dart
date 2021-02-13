// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/index.dart';
// import '../../util/style.dart';
//
// class ThemeSwitch extends StatefulWidget {
//   @override
//   _ThemeSwitchState createState() => _ThemeSwitchState();
// }
//
// class _ThemeSwitchState extends State<ThemeSwitch> {
//   bool _ignoreOnPress = true;
//   bool _isDarkTheme = false;
//
//   @override
//   Widget build(BuildContext context) {
//     _isDarkTheme = ThemeProvider.of(context).brightness == Brightness.dark;
//     final themeData = Provider.of<ThemesProvider>(context, listen: false);
//     return ThemeSwitcher(
//       builder: (context) => IconButton(
//         splashRadius: 20,
//         icon: Icon(
//           _isDarkTheme ? MdiIcons.weatherSunny : MdiIcons.weatherNight,
//         ),
//         onPressed: _ignoreOnPress
//             ? () {
//                 _ignoreOnPress = false;
//                 Timer(
//                   const Duration(milliseconds: 400),
//                   () => setState(
//                     () => _ignoreOnPress = true,
//                   ),
//                 );
//                 _isDarkTheme = !_isDarkTheme;
//                 themeData.setTheme(_isDarkTheme);
//                 ThemeSwitcher.of(context).changeTheme(
//                   theme:
//                       ThemeProvider.of(context).brightness == Brightness.light
//                           ? Style.dark
//                           : Style.light,
//                   reverseAnimation:
//                       ThemeProvider.of(context).brightness == Brightness.dark,
//                 );
//               }
//             : () {},
//       ),
//     );
//   }
// }

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
