import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that auth & retrieves user from [ApiService].
class AuthService extends BaseService {
  const AuthService(Dio client) : super(client);

  /// Send a user auth data.
  Future<Response> auth({
    @required String login,
    @required String pwd,
  }) async {
    return client.post(
      Url.loginUrl,
      data: {
        "email": login,
        "password": pwd,
      },
    );
  }

  /// Retrieve current user data.
  Future<Response> getUser({
    @required String uid,
    @required String token,
  }) async {
    return client.get(
      '${Url.userUrl}/$uid',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
