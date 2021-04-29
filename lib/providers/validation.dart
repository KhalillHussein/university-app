import 'package:flutter/material.dart';

import '../models/index.dart';

class ValidationProvider with ChangeNotifier {
  ValidationItem _login = ValidationItem(null, null);

  ValidationItem _password = ValidationItem(null, null);

  ValidationItem _phoneNumber = ValidationItem(null, null);

  ValidationItem _organizationName = ValidationItem(null, null);

  ValidationItem _location = ValidationItem(null, null);

  final Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //Getters
  ValidationItem get login => _login;

  ValidationItem get password => _password;

  ValidationItem get phoneNumber => _phoneNumber;

  ValidationItem get organizationName => _organizationName;

  ValidationItem get location => _location;

  bool get isInquiryFormValid {
    if (_phoneNumber.value != null &&
        _location.value != null &&
        _organizationName.value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isAuthFormValid {
    if (_login.value != null && _password.value != null) {
      return true;
    } else {
      return false;
    }
  }

  void changeLogin(String value) {
    final RegExp regex = RegExp(pattern, caseSensitive: false);
    if (regex.hasMatch(value)) {
      _login = ValidationItem(value, null);
    } else {
      _login = ValidationItem(null, 'Неверный формат email');
    }
    notifyListeners();
  }

  void changePassword(String value) {
    if (value.length >= 5) {
      _password = ValidationItem(value, null);
    } else {
      _password =
          ValidationItem(null, 'Пароль должен быть не менее 5 символов');
    }
    notifyListeners();
  }

  void changeLocation(String value) {
    if (value.length > 9) {
      _location = ValidationItem(value, null);
    } else {
      _location = ValidationItem(null,
          'Слишком короткая запись. Запись должна содержать не менее 10 символов');
    }
    notifyListeners();
  }

  void changePhoneNumber(String value) {
    final phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\-\d\d$');
    if (phoneExp.hasMatch(value)) {
      _phoneNumber = ValidationItem(value, null);
    } else {
      _phoneNumber = ValidationItem(null, 'Номер указан неверно');
    }
    notifyListeners();
  }

  void changeCompanyName(String value) {
    if (value.length > 5) {
      _organizationName = ValidationItem(value, null);
    } else {
      _organizationName = ValidationItem(null,
          'Слишком короткая запись. Запись должна содержать не менее 6 символов');
    }
    notifyListeners();
  }
}
