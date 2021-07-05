import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/index.dart';
import '../util/exception.dart';
import 'index.dart';

class NotificationsRepository extends BaseRepository<NotificationsService> {
  String uid;
  String notificationTokenCurrent;
  String bearerToken;
  String notificationTokenFromAPI;

  NotificationsRepository(NotificationsService service)
      : super(service, autoLoad: false);

  bool get isNotify => notificationTokenFromAPI != null;

  @override
  Future<void> loadData() async {
    try {
      final userResponse = await service.enableNotifications(
        uid: uid,
        token: notificationTokenCurrent,
        authToken: bearerToken,
      );
      notificationTokenFromAPI =
          userResponse.data['result']['notificationToken'];
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  Future<void> disableNotifications() async {
    try {
      final userResponse = await service.disableNotifications(
        uid: uid,
        authToken: bearerToken,
      );
      notificationTokenFromAPI =
          userResponse.data['result']['notificationToken'];
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  void update({String userId, String userToken, String notificationToken}) {
    uid = userId;
    bearerToken = userToken;
    notificationTokenFromAPI = notificationToken;
    tokenInit();
  }

  Future<void> tokenInit() async {
    notificationTokenCurrent = await FirebaseMessaging.instance.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String notificationTokenFromLocalStorage =
        prefs.getString('fcm_token');
    if (notificationTokenFromLocalStorage == notificationTokenCurrent &&
        notificationTokenCurrent == notificationTokenFromAPI) return;
    prefs.setString('fcm_token', notificationTokenCurrent);
    if (isNotify) {
      loadData();
    }
  }
}
