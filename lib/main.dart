import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import './repositories/index.dart';
import './services/index.dart';
import './util/index.dart';
import 'providers/index.dart';

int messageCount = 0;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
  FlutterAppBadger.updateBadgeCount(++messageCount);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences.getInstance().then((prefs) {
    final bool darkModeOn = prefs.getBool('theme') ?? false;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: darkModeOn ? k04dp : Colors.grey[100],
        systemNavigationBarIconBrightness:
            darkModeOn ? Brightness.light : Brightness.dark,
      ),
    );
    runApp(ChangeNotifierProvider<ThemesProvider>(
      create: (_) => ThemesProvider(darkModeOn ? Style.dark : Style.light),
      child: App(),
    ));
  });
}

/// Builds the necessary providers, as well as the home page.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpClient = Dio();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationsProvider>(
          create: (_) => NotificationsProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => TimetableUploadProvider()),
        ChangeNotifierProvider(create: (ctx) => InquiryProvider()),
        ChangeNotifierProvider(
          create: (ctx) => TextScaleProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (ctx) => ImageQualityProvider()),
        ChangeNotifierProvider(
          create: (ctx) => AuthRepository(AuthService(httpClient)),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AuthRepository, NewsCreateRepository>(
          create: (ctx) => NewsCreateRepository(
            NewsCreateService(httpClient),
          ),
          update: (ctx, auth, model) => model..token = auth.token,
        ),
        ChangeNotifierProvider(
          create: (ctx) => TimetableUploadRepository(
            TimetableUploadService(httpClient),
          ),
        ),
        ChangeNotifierProxyProvider<AuthRepository, NotificationsRepository>(
          create: (ctx) =>
              NotificationsRepository(NotificationsService(httpClient)),
          update: (ctx, auth, model) => model
            ..update(
              notificationToken: auth.user?.notificationToken,
              userId: auth.user?.userId,
              userToken: auth.token,
            ),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (ctx) => NewsCreateProvider()),
        ChangeNotifierProvider(
            create: (ctx) => LecturersRepository(LecturersService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => NewsRepository(NewsService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => PhoneBookRepository(PhoneBookService(httpClient))),
        ChangeNotifierProvider(
            create: (ctx) => TimetableRepository(TimetableService(httpClient))),
        ChangeNotifierProxyProvider<TimetableRepository, TableCalendarProvider>(
          create: (ctx) => TableCalendarProvider([]),
          update: (ctx, model, tableCalendar) =>
              TableCalendarProvider(model.getBy(model.userCategory)),
        ),
      ],
      child: Consumer<ThemesProvider>(builder: (ctx, themeData, _) {
        return ThemeProvider(
          initTheme: themeData.getTheme(),
          child: Builder(builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate
              ],
              supportedLocales: const [Locale('ru')],
              title: 'MTUСI APP',
              theme: ThemeProvider.of(context),
              darkTheme: Style.dark,
              onGenerateRoute: Routes.generateRoute,
              onUnknownRoute: Routes.errorRoute,
            );
          }),
        );
      }),
    );
  }
}
