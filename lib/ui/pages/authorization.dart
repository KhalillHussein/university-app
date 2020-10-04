import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_form.dart';

class AuthorizationPage extends StatefulWidget {
  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit({
    String login,
    String password,
  }) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false)
          .login(login.trim(), password.trim());
    } on HttpException catch (error) {
      var errorMessage = 'Ошибка авторизации. Повторите попытку позже.';
      if (error.toString().contains('WRONG_PASSWORD')) {
        errorMessage = 'Неверный пароль.';
      } else if (error.toString().contains('USER_DOES_NOT_EXIST')) {
        errorMessage = 'Пользователя с таким именем не существует.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Невозможно выполнить авторизацию. Повторите попытку позже.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submit, _isLoading),
    );
  }
}
