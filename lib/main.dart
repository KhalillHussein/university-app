import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mtusiapp/repositories/news_edit.dart';
import 'package:mtusiapp/services/news_edit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:intl/date_symbol_data_local.dart';

import './repositories/index.dart';
import './services/index.dart';
import './util/index.dart';
import 'providers/index.dart';

void main() {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    final bool darkModeOn = prefs.getBool('theme') ?? false;
    runApp(
      ChangeNotifierProvider<ThemesProvider>(
        create: (_) => ThemesProvider(darkModeOn ? Style.dark : Style.light),
        child: App(),
      ),
    );
  });
}

/// Builds the necessary providers, as well as the home page.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpClient = Dio();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => RadioProvider()),
        ChangeNotifierProvider(create: (ctx) => TextScaleProvider()),
        ChangeNotifierProvider(
            create: (ctx) => AuthRepository(AuthService(httpClient))),
        ChangeNotifierProxyProvider<AuthRepository, NewsEditRepository>(
          create: (ctx) => NewsEditRepository(NewsEditService(httpClient)),
          lazy: true,
          update: (ctx, model, model2) =>
              NewsEditRepository(NewsEditService(httpClient))
                ..token = model.user.token,
        ),
        ChangeNotifierProvider(
            create: (ctx) => LecturersRepository(LecturersService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => NewsRepository(NewsService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => PhoneBookRepository(PhoneBookService(httpClient))),
        ChangeNotifierProvider(create: (ctx) => NotificationsProvider()),
        ChangeNotifierProvider(
            create: (ctx) => TimetableRepository(TimetableService(httpClient))),
        ChangeNotifierProxyProvider<TimetableRepository, TableCalendarProvider>(
          create: (ctx) => TableCalendarProvider(),
          update: (ctx, model, tableCalendar) => TableCalendarProvider()
            ..timetableList = model.getBy(model.userCategory),
        ),
      ],
      child: Consumer<ThemesProvider>(builder: (ctx, themeData, _) {
        return ThemeProvider(
          initTheme: themeData.getTheme(),
          child: Builder(
            builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MTUСI APP',
              theme: ThemeProvider.of(context),
              darkTheme: Style.dark,
              onGenerateRoute: Routes.generateRoute,
              onUnknownRoute: Routes.errorRoute,
            ),
          ),
        );
      }),
    );
  }
}
