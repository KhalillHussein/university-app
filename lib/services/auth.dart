import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves user from [ApiService].
class AuthService extends BaseService {
  const AuthService(Dio client) : super(client);

  /// Retrieves a user info.
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
