import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serves as a way to communicate with the notification system.
class NotificationsProvider with ChangeNotifier {
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationsProvider() {
    init();
  }

  Future<void> init() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    final initializationAndroidSettings =
        AndroidInitializationSettings('@drawable/ic_stat_app_icon');
    final initializationSettings =
        InitializationSettings(android: initializationAndroidSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    onMessage();
  }

  StreamSubscription<RemoteMessage> onMessage() {
    return FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      int messageCount = 0;
      final RemoteNotification notification = message.notification;
      final AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              importance: channel.importance,
              icon: 'ic_stat_app_icon',
            ),
          ),
        );
        FlutterAppBadger.updateBadgeCount(++messageCount);
      }
    });
  }
}
