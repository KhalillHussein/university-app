import 'package:flutter/material.dart';

import '../models/index.dart';

class ValidationProvider with ChangeNotifier {
  ValidationItem _login = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  final Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //Getters
  ValidationItem get login => _login;
  ValidationItem get password => _password;

  bool get isValid {
    if (_login.value != null && _password.value != null) {
      return true;
    } else {
      return false;
    }
  }

  //Setters
  void changeLogin(String value) {
    final RegExp regex = RegExp(pattern, caseSensitive: false);
    if (regex.hasMatch(value)) {
      _login = ValidationItem(value, null);
    } else {
      _login = ValidationItem(null, 'Неверный email');
    }
    notifyListeners();
  }

  void changePassword(String value) {
    if (value.length >= 5) {
      _password = ValidationItem(value, null);
    } else {
      _password = ValidationItem(null, 'Пароль слишком короткий');
    }
    notifyListeners();
  }
}
