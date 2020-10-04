import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:intl/date_symbol_data_local.dart';

import './repositories/index.dart';
import './util/routes.dart';
import './util/style.dart';
import 'providers/index.dart';

void main() {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    final bool darkModeOn = prefs.getBool('theme') ?? false;
    runApp(
      ChangeNotifierProvider<ThemesProvider>(
        create: (_) => ThemesProvider(darkModeOn ? Style.dark : Style.light),
        child: MyApp(),
      ),
    );
  });
}

/// Builds the necessary providers, as well as the home page.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth(), lazy: false),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => ScheduleRepository()),
        ChangeNotifierProvider(create: (ctx) => LecturersRepository()),
        ChangeNotifierProvider(create: (ctx) => NewsRepository()),
        ChangeNotifierProvider(
            create: (ctx) => NotificationsProvider(), lazy: false),
      ],
      child: Consumer<ThemesProvider>(
        builder: (ctx, themeData, _) => ThemeProvider(
          initTheme: themeData.getTheme(),
          child: Builder(
            builder: (context) => MaterialApp(
              title: 'MTUSI APP',
              theme: ThemeProvider.of(context),
              darkTheme: Style.dark,
              onGenerateRoute: Routes.generateRoute,
              onUnknownRoute: Routes.errorRoute,
            ),
          ),
        ),
      ),
    );
  }
}
