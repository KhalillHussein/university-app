import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that setting up notifications.
class NotificationsService extends BaseService {
  const NotificationsService(Dio client) : super(client);

  /// Send request to enable notifications for current user.
  Future<Response> enableNotifications(
      {String uid, String token, String authToken}) async {
    return client.patch('${Url.baseUrl}/users/$uid/notifications/on',
        data: {'token': token},
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ));
  }

  /// Send request to disable notifications for current user.
  Future<Response> disableNotifications({String uid, String authToken}) async {
    return client.patch(
      '${Url.baseUrl}/users/$uid/notifications/off',
      options: Options(
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      ),
    );
  }
}
