import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

enum Positions { student, lecturer, admin, stuff, unauthorized }

///Repository that manage authentication process
class AuthRepository extends BaseRepository<AuthService> {
  String _token;

  User _user;

  SharedPreferences _prefs;

  AuthRepository(AuthService service) : super(service);

  bool get isAuth => _token != null;

  User get user => _user;

  ///Function that checks if token contains in local memory
  @override
  Future<void> loadData() async {
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
      finishLoading();
    } catch (e) {
      receivedError(e.toString());
    }
  }

  ///Function to perform API request
  Future<void> authenticate(String email, String password) async {
    startLoading();
    try {
      final userResponse = await service.getUser(login: email, pwd: password);
      _user = User.fromJson(userResponse.data['result']);
      _token = _user.token;
      finishLoading();
      final userData = _toStr(_user);
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
  String _toStr(User user) {
    return json.encode({
      'token': user.token,
      'userId': user.userId,
      'username': user.userName,
      'email': user.email,
      'role': user.role,
    });
  }

  Positions getUserPosition() {
    switch (_user?.role) {
      case 'student':
        return Positions.student;
        break;
      case 'lecturer':
        return Positions.lecturer;
        break;
      case 'admin':
        return Positions.admin;
      case 'stuff':
        return Positions.stuff;
        break;
      default:
        return Positions.unauthorized;
        break;
    }
  }

  ///Function that performs logout operations
  Future<void> logout() async {
    _user = User.fromJson({});
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
}
