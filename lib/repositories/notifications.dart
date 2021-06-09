import 'package:dio/dio.dart';
import 'package:mtusiapp/repositories/base.dart';
import 'package:mtusiapp/services/notifications.dart';
import 'package:mtusiapp/util/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRepository extends BaseRepository<NotificationsService> {
  String uid;
  String token;
  String authToken;
  bool isNotify = false;

  NotificationsRepository(NotificationsService service) : super(service) {
    init();
  }

  @override
  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await service.enableNotifications(
        uid: uid,
        token: token,
        authToken: authToken,
      );
      isNotify = true;
      prefs.setBool('notify', isNotify);
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  Future<void> disableNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await service.disableNotifications(
        uid: uid,
        authToken: authToken,
      );
      isNotify = false;
      prefs.setBool('notify', isNotify);
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  void update({String fcmToken, String userId, String userToken}) {
    token = fcmToken;
    uid = userId;
    authToken = userToken;
    tokenInit();
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      isNotify = prefs.getBool('notify');
    } catch (e) {
      prefs.setBool('notify', false);
    }
    notifyListeners();
  }

  Future<void> tokenInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fcmToken = prefs.getString('fcm_token');
    if (fcmToken == token) return;
    token = fcmToken;
    prefs.setString('fcm_token', token);
    if (isNotify) {
      loadData();
    }
  }
}
