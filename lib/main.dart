import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mtusiapp/providers/image_quality.dart';
import 'package:mtusiapp/repositories/news_create.dart';
import 'package:mtusiapp/services/news_create.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './repositories/index.dart';
import './services/index.dart';
import './util/index.dart';
import 'providers/index.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
// }
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //
  // // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

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
//   @override
//   _AppState createState() => _AppState();
// }
//
// class _AppState extends State<App> {
//   @override
//   void initState() {
//     var InitializationAndroidSettings =
//         AndroidInitializationSettings('@mipmap/ic_stat_app_icon');
//     var initializationSettings =
//         InitializationSettings(android: InitializationAndroidSettings);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channel.description,
//                 // TODO add a proper drawable resource to android, for now using
//                 //      one that already exists in example app.
//                 icon: 'notification_icon',
//               ),
//             ));
//       }
//     });
//     getToken();
//     super.initState();
//   }
//
//   Future<void> getToken() async {
//     FirebaseMessaging.instance.getToken().then(
//           (token) => sendTokenToServer(token),
//         );
//   }
//
//   Future<void> sendTokenToServer(String token) async {
//     // try {
//     //   var uuid = UniqueKey().toString();
//     //   var url = 'http://188.93.210.205:3000/users/$uuid/notifications/on';
//     //   var response = await Dio().patch(url, data: {'token': token});
//     //   print('Response status: ${response.statusCode}');
//     //   print('Response body: ${response.data}');
//     // } on DioError catch (dioError) {
//     //   print('error' + dioError.toString());
//     // } catch (error) {
//     //   print('error' + error);
//     // }
//   }

  @override
  Widget build(BuildContext context) {
    final httpClient = Dio();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => RadioProvider()),
        ChangeNotifierProvider(create: (ctx) => TextScaleProvider()),
        ChangeNotifierProvider(create: (ctx) => ImageQualityProvider()),
        ChangeNotifierProvider(
            create: (ctx) => AuthRepository(AuthService(httpClient))),
        ChangeNotifierProxyProvider<AuthRepository, NewsCreateRepository>(
          create: (ctx) => NewsCreateRepository(NewsCreateService(httpClient)),
          lazy: true,
          update: (ctx, model, model2) =>
              NewsCreateRepository(NewsCreateService(httpClient))
                ..token = model.user.token,
        ),
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
          child: Builder(
            builder: (context) => MaterialApp(
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
            ),
          ),
        );
      }),
    );
  }
}
