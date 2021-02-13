import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

/// Serves as a way to communicate with the notification system.
class NotificationsProvider with ChangeNotifier {
  final _notifications = FlutterLocalNotificationsPlugin();

  final _notificationDetailsNews = NotificationDetails(
    AndroidNotificationDetails(
      'channel.news',
      'News notifications',
      'Stay up-to-date with upcoming news',
      importance: Importance.High,
    ),
    IOSNotificationDetails(),
  );

  final _notificationDetailsSchedule = NotificationDetails(
    AndroidNotificationDetails(
      'channel.schedule',
      'Schedule notifications',
      'Stay up-to-date with schedule changing',
      importance: Importance.High,
    ),
    IOSNotificationDetails(),
  );

  NotificationsProvider() {
    init();
  }

  /// Initializes the notifications system
  Future<void> init() async {
    await _notifications.initialize(
      InitializationSettings(
        AndroidInitializationSettings('@mipmap/ic_launcher'),
        IOSInitializationSettings(),
      ),
    );
  }

  /// Cancels all pending notifications
  Future<void> cancelAll() async => _notifications.cancelAll();

  //
  // Future<void> showNotifications() async {
  //   var channelNews = IOWebSocketChannel.connect("wss://echo.websocket.org/");
  //   channelNews.sink.add('Новость');
  //   channelNews.stream.listen((message) async {
  //     await context
  //         .read<NotificationsProvider>()
  //         .notificationsNews(title: 'Новости', body: message);
  //   });
  //   var channelSchedule =
  //   IOWebSocketChannel.connect("wss://echo.websocket.org/");
  //   channelSchedule.sink.add('Изменение в расписании');
  //   channelSchedule.stream.listen((message) async {
  //     await context
  //         .read<NotificationsProvider>()
  //         .notificationsSchedule(title: 'Расписание', body: message);
  //   });
  // }

  /// Schedule new notifications
  Future<void> notificationsNews({String title, String body}) async {
    await _notifications.show(
      0,
      title,
      body,
      _notificationDetailsNews,
    );
  }

  Future<void> notificationsSchedule({String title, String body}) async {
    await _notifications.show(
      1,
      title,
      body,
      _notificationDetailsSchedule,
    );
  }
}
