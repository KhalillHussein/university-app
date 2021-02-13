// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
//
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
// import 'package:intl/date_symbol_data_local.dart';
//
// import './repositories/index.dart';
// import './services/index.dart';
// import './util/index.dart';
// import 'providers/index.dart';
//
// // void main() {
// //   initializeDateFormatting();
// //   WidgetsFlutterBinding.ensureInitialized();
// //   SharedPreferences.getInstance().then((prefs) {
// //     final bool darkModeOn = prefs.getBool('theme') ?? false;
// //     runApp(
// //       ChangeNotifierProvider<ThemesProvider>(
// //         create: (_) => ThemesProvider(darkModeOn ? Style.dark : Style.light),
// //         child: App(),
// //       ),
// //     );
// //   });
// // }
//
// void main() {
//   initializeDateFormatting();
//   runApp(App());
// }
//
// /// Builds the necessary providers, as well as the home page.
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final httpClient = Dio();
//     FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (ctx) => ThemesProvider()),
//         ChangeNotifierProvider(
//             create: (ctx) => Auth(AuthService(httpClient)), lazy: false),
//         ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
//         ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
//         ChangeNotifierProvider(
//             create: (ctx) => TimetableRepository(TimetableService(httpClient))),
//         ChangeNotifierProvider(
//             create: (ctx) => LecturersRepository(LecturersService(httpClient))),
//         ChangeNotifierProvider(
//             create: (ctx) => NewsRepository(NewsService(httpClient))),
//         ChangeNotifierProvider(create: (ctx) => NotificationsProvider()),
//       ],
//       child: Consumer<ThemesProvider>(builder: (ctx, themeData, _) {
//         return ThemeProvider(
//           initTheme: themeData.getTheme(),
//           child: Builder(
//             builder: (context) => MaterialApp(
//               title: 'MTUSI APP',
//               theme: ThemeProvider.of(context),
//               darkTheme: Style.dark,
//               onGenerateRoute: Routes.generateRoute,
//               onUnknownRoute: Routes.errorRoute,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (ctx) => Auth(AuthService(httpClient)), lazy: false),
        ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (ctx) => TimetableRepository(TimetableService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => LecturersRepository(LecturersService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => NewsRepository(NewsService(httpClient))),
        ChangeNotifierProvider(create: (ctx) => NotificationsProvider()),
      ],
      child: Consumer<ThemesProvider>(builder: (ctx, themeData, _) {
        return ThemeProvider(
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
        );
      }),
    );
  }
}
