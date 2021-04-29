import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves user from [ApiService].
class AuthService extends BaseService {
  const AuthService(Dio client) : super(client);

  /// Send a user data.
  Future<Response> getUser(
      {@required String login, @required String pwd}) async {
    return client.post(
      Url.loginUrl,
      data: {
        "email": login,
        "password": pwd,
      },
    );
  }
}
