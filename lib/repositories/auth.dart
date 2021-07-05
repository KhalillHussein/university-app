import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

///Repository that manage authentication process
class AuthRepository extends BaseRepository<AuthService> {
  User _user;
  String _token;

  SharedPreferences _prefs;

  AuthRepository(AuthService service) : super(service, autoLoad: false) {
    init();
  }

  bool get isAuth => _token != null;

  User get user => _user;
  String get token => _token;

  ///Function that checks if token contains in local memory
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey('userData')) {
        finishLoading();
        return;
      }
      final extractedUserData =
          json.decode(_prefs.getString('userData')) as Map<String, dynamic>;
      _user = User.fromJson(extractedUserData);
      _token = _user.token;
      loadData();
    } catch (e) {
      receivedError(e.toString());
    }
  }

  ///Function to perform API request
  Future<void> authenticate(String email, String password) async {
    startLoading();
    try {
      final userResponse = await service.auth(login: email, pwd: password);
      _user = User.fromJson(userResponse.data['result']);
      finishLoading();
      final userData = _toStr();
      _token = _user.token;
      _prefs.setString('userData', userData);
    } on DioError catch (dioError) {
      try {
        final String e = dioError.response.data['errors']['msg'];
        receivedError(ApiException.authError(e).message);
      } catch (e) {
        receivedError(ApiException.fromDioError(dioError).message);
      }
    } catch (error) {
      receivedError(error.toString());
    }
  }

  ///Parse data to json for saving on device local storage
  String _toStr() {
    return json.encode({
      'token': _user.token,
      'userId': _user.userId,
      'username': _user.userName,
      'email': _user.email,
      'role': _user.role,
    });
  }

  ///Function that delete user from memory
  Future<void> logout() async {
    _user = null;
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  ///Function that get user from API
  @override
  Future<void> loadData() async {
    try {
      final userResponse =
          await service.getUser(uid: _user.userId, token: token);
      _user = User.fromJson(userResponse.data['result']);
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }
}
