import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../util/url.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _name;
  String _email;
  String _role;

  Auth() {
    _tryAutoLogin();
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  String get userName {
    return _name;
  }

  String get email {
    return _email;
  }

  String get role {
    return _role;
  }

  Future<void> _authenticate(String email, String password) async {
    final url = Url.loginUrl;
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
          }),
          headers: {"Content-Type": "application/json"});
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors']['msg']);
      }
      var result = responseData['result'];
      _token = result['token'];
      _userId = result['user']['_id'];
      _name = result['user']['name'];
      _email = result['user']['email'];
      _role = result['user']['role'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'username': _name,
        'email': _email,
        'role': _role,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<bool> _tryAutoLogin() async {
    print('auto login process..');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _name = extractedUserData['username'];
    _email = extractedUserData['email'];
    _role = extractedUserData['role'];
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
}
