import 'package:flutter/material.dart';

import '../../util/colors.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final void Function({
    String login,
    String password,
  }) submitFn;

  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  var _loginFieldHasData = false;
  var _pwdFieldHasData = false;

  final Map<String, String> _authData = {
    'login': '',
    'password': '',
  };

  Future<void> _trySubmit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    widget.submitFn(
      login: _authData['login'],
      password: _authData['password'],
    );
  }

  bool validateEmail(String value) {
    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern, caseSensitive: false);
    return regex.hasMatch(value) ? false : true;
  }

  Widget _buildTextFieldEmail(BuildContext context) {
    return TextFormField(
      focusNode: _loginFocusNode,
      maxLength: 20,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Логин',
        alignLabelWithHint: true,
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: (value) {
        if (value.isEmpty || validateEmail(value)) {
          return 'Неверный email';
        }
        return null;
      },
      onSaved: (value) {
        _authData['login'] = value;
      },
      onChanged: (text) {
        setState(() {
          text.isEmpty ? _loginFieldHasData = false : _loginFieldHasData = true;
        });
      },
    );
  }

  Widget _buildTextFieldPassword(BuildContext context) {
    return TextFormField(
      maxLength: 20,
      focusNode: _passwordFocusNode,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Пароль',
        alignLabelWithHint: true,
      ),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value.isEmpty || value.length < 5) {
          return 'Пароль слишком короткий';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value;
      },
      onChanged: (text) {
        setState(() {
          text.isEmpty ? _pwdFieldHasData = false : _pwdFieldHasData = true;
        });
      },
    );
  }

  Widget _buildAuthButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        elevation: 2,
        disabledColor: Theme.of(context).disabledColor,
        disabledTextColor: Theme.of(context).textTheme.button.color,
        textColor: Theme.of(context).textTheme.headline5.color,
        color: Theme.of(context).accentColor,
        shape: const StadiumBorder(),
        onPressed: _pwdFieldHasData && _loginFieldHasData ? _trySubmit : null,
        child: widget.isLoading
            ? const SizedBox(
                height: 22.0,
                width: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text(
                'ВХОД',
                style: TextStyle(fontSize: 15),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: kAccentThemeColor,
        accentColor: kAccentThemeColor,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Авторизация',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 40,
                ),
                _buildTextFieldEmail(context),
                _buildTextFieldPassword(context),
                _buildAuthButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
