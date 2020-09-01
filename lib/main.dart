import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:intl/date_symbol_data_local.dart';

import './providers/news_provider.dart';
import './providers/teacher_provider.dart';
import './providers/auth.dart';
import './providers/schedule_provider.dart';
import './providers/themes_provider.dart';
import './providers/navigation_provider.dart';
import './screens/navigation_screen.dart';
import './screens/teachers_screen.dart';
import './screens/photo_view_screen.dart';
import './values/themes.dart';

void main() {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    bool darkModeOn = prefs.getBool('theme') ?? false;
    runApp(
      ChangeNotifierProvider<ThemesProvider>(
        create: (_) => ThemesProvider(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth(), lazy: false),
        ChangeNotifierProvider(create: (ctx) => ScheduleProvider()),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => TeacherProvider()),
        ChangeNotifierProxyProvider<Auth, NewsProvider>(
          create: (ctx) => NewsProvider('', '', []),
          update: (ctx, auth, previousNews) => NewsProvider(
            auth.token,
            auth.userId,
            previousNews == null ? [] : previousNews.items,
          ),
        ),
      ],
      child: Consumer<ThemesProvider>(
        builder: (ctx, themeData, _) => ThemeProvider(
          initTheme: themeData.getTheme(),
          child: Builder(
            builder: (context) => MaterialApp(
              title: 'MTUSI APP',
              theme: ThemeProvider.of(context),
              darkTheme: darkTheme,
              onUnknownRoute: (RouteSettings routeSettings) =>
                  MaterialPageRoute(
                settings: routeSettings,
                builder: (_) => NavigationScreen(),
              ),
              initialRoute: '/',
              routes: {
                '/': (ctx) => NavigationScreen(),
                TeachersScreen.routeName: (ctx) => TeachersScreen(),
                PhotoViewScreen.routeName: (ctx) => PhotoViewScreen(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
