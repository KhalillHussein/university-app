import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class AuthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Авторизация',
      leading: IconButton(
        splashRadius: 20,
        tooltip: 'Меню',
        icon: const Icon(MdiIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      actions: [
        ThemeSwitchIcon(),
        IconButton(
          splashRadius: 20,
          icon: const Icon(MdiIcons.cogOutline),
          onPressed: () => Navigator.pushNamed(context, SettingsScreen.route),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 35.0),
          child: Column(
            children: [
              Separator.spacer(
                  space: MediaQuery.of(context).size.height * 0.14),
              _buildTextFieldEmail(context),
              Separator.spacer(),
              _buildTextFieldPwd(context),
              Separator.spacer(),
              _buildAuthButton(context),
              Separator.spacer(),
              Text(
                'Функционал личного кабинета в разработке и на данный момент недоступен.',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
                textScaleFactor: 0.95,
                textAlign: TextAlign.center,
              ).scalable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail(BuildContext context) {
    return Consumer<ValidationProvider>(
      builder: (ctx, validation, _) => TextFormField(
        maxLength: 20,
        initialValue: validation.login.value,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Логин',
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
      builder: (ctx, validation, _) => PasswordField(
        textInputAction: TextInputAction.next,
        errorText: validation.password.error,
        initialValue: validation.password.value,
        labelText: 'Пароль',
        onChanged: (value) => validation.changePassword(value),
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
                    _showSnackBar(context, auth.errorMessage);
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).errorColor,
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).primaryColor,
              ),
              Separator.spacer(),
              Expanded(
                child: Text(
                  message,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final String errorText;
  final String initialValue;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final TextInputAction textInputAction;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        errorMaxLines: 2,
        suffixIcon: UnconstrainedBox(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }
}
