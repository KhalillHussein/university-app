import 'package:flutter/material.dart';

Widget buildSnackBar(BuildContext context) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
    content: Text(
      'Невозможно получить данные. Проверьте подключение к интернету',
      style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
    ),
    duration: Duration(seconds: 1),
  );
}
