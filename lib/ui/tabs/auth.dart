import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';

class AuthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).brightness == Brightness.light
                ? kLightPrimaryColor
                : kDarkPrimaryColor,
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.14),
              _buildTextFieldEmail(context),
              _buildTextFieldPwd(context),
              _buildAuthButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail(BuildContext context) {
    return Consumer<ValidationProvider>(
      builder: (ctx, validation, _) => TextFormField(
        maxLength: 30,
        initialValue: validation.login.value,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Логин',
          alignLabelWithHint: true,
          errorText: validation.login.error,
        ),
        onChanged: (text) {
          validation.changeLogin(text);
        },
      ),
    );
  }

  Widget _buildTextFieldPwd(BuildContext context) {
    return Consumer<ValidationProvider>(
      builder: (ctx, validation, _) => TextFormField(
        maxLength: 30,
        obscureText: true,
        initialValue: validation.password.value,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Пароль',
          alignLabelWithHint: true,
          errorText: validation.password.error,
        ),
        onChanged: (text) {
          validation.changePassword(text);
        },
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context) {
    return Consumer2<ValidationProvider, AuthRepository>(
      builder: (ctx, validation, auth, _) => Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(top: 10),
        child: MaterialButton(
          elevation: 2,
          disabledColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
          textColor: Colors.white,
          color: Theme.of(context).accentColor,
          shape: const StadiumBorder(),
          onPressed: (!validation.isAuthFormValid)
              ? null
              : () async {
                  await auth.authenticate(
                      validation.login.value, validation.password.value);
                  if (auth.loadingFailed) {
                    _showErrorDialog(context, auth.errorMessage);
                  }
                },
          child: auth.isLoading
              ? const SizedBox(
                  height: 22.0,
                  width: 22.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text('ВХОД', style: TextStyle(fontSize: 15)),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }
}
