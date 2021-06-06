import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//
// /// Serves as a way to communicate with the notification system.
// class NotificationsProvider with ChangeNotifier {
//   FirebaseMessaging _messaging;
//
//   NotificationsProvider() {
//     init();
//     getToken();
//   }
//
//   /// Initializes the notifications system
//   Future<void> init() async {
//     // 1. Initialize the Firebase app
//     await Firebase.initializeApp();
//
//     // 2. Instantiate Firebase Messaging
//     _messaging = FirebaseMessaging.instance;
//
//     // 3. On iOS, this helps to take the user permissions
//     final NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//
//       // For handling the received notifications
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         // Parse the message received
//         PushNotification notification = PushNotification(
//           title: message.notification?.title,
//           body: message.notification?.body,
//         );
//         if (_notificationInfo != null) {
//           // For displaying the notification as an overlay
//           showSimpleNotification(
//             Text(_notificationInfo.title),
//             leading: NotificationBadge(totalNotifications: _totalNotifications),
//             subtitle: Text(_notificationInfo.body),
//             background: Colors.cyan.shade700,
//             duration: Duration(seconds: 2),
//           );
//         }
//       });
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
//
//   Future<void> getToken() async {
//     String token = await FirebaseMessaging.instance.getToken();
//     print(token);
//   }

// final _notifications = FlutterLocalNotificationsPlugin();
//
// final _notificationDetailsNews = NotificationDetails(
//   AndroidNotificationDetails(
//     'channel.news',
//     'News notifications',
//     'Stay up-to-date with upcoming news',
//     importance: Importance.High,
//   ),
//   IOSNotificationDetails(),
// );
//
// final _notificationDetailsSchedule = NotificationDetails(
//   AndroidNotificationDetails(
//     'channel.schedule',
//     'Schedule notifications',
//     'Stay up-to-date with schedule changing',
//     importance: Importance.High,
//   ),
//   IOSNotificationDetails(),
// );
//
// NotificationsProvider() {
//   init();
// }
//
// /// Initializes the notifications system
// Future<void> init() async {
//   await _notifications.initialize(
//     InitializationSettings(
//       AndroidInitializationSettings('@mipmap/ic_launcher'),
//       IOSInitializationSettings(),
//     ),
//   );
// }
//
// /// Cancels all pending notifications
// Future<void> cancelAll() async => _notifications.cancelAll();
//
// //
// // Future<void> showNotifications() async {
// //   var channelNews = IOWebSocketChannel.connect("wss://echo.websocket.org/");
// //   channelNews.sink.add('Новость');
// //   channelNews.stream.listen((message) async {
// //     await context
// //         .read<NotificationsProvider>()
// //         .notificationsNews(title: 'Новости', body: message);
// //   });
// //   var channelSchedule =
// //   IOWebSocketChannel.connect("wss://echo.websocket.org/");
// //   channelSchedule.sink.add('Изменение в расписании');
// //   channelSchedule.stream.listen((message) async {
// //     await context
// //         .read<NotificationsProvider>()
// //         .notificationsSchedule(title: 'Расписание', body: message);
// //   });
// // }
//
// /// Schedule new notifications
// Future<void> notificationsNews({String title, String body}) async {
//   await _notifications.show(
//     0,
//     title,
//     body,
//     _notificationDetailsNews,
//   );
// }
//
// Future<void> notificationsSchedule({String title, String body}) async {
//   await _notifications.show(
//     1,
//     title,
//     body,
//     _notificationDetailsSchedule,
//   );
// }
// }

// class PushNotification {
//   PushNotification({
//     this.title,
//     this.body,
//   });
//   String title;
//   String body;
// }
