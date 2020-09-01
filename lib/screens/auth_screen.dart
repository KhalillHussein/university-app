// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../models/http_exception.dart';
// import '../providers/auth.dart';
// import '../util/colors.dart';
//
// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   FocusNode _loginFocusNode = FocusNode();
//   FocusNode _passwordFocusNode = FocusNode();
//
//   Map<String, String> _authData = {
//     'login': '',
//     'password': '',
//   };
//
//   var _loginFieldHasData = false;
//   var _pwdFieldHasData = false;
//   var _isLoading = false;
//
//   @override
//   void dispose() {
//     _loginFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     super.dispose();
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Ошибка'),
//         content: Text(message),
//         actions: <Widget>[
//           FlatButton(
//               child: const Text('ОК'),
//               textColor: Theme.of(context).accentColor,
//               onPressed: () {
//                 Navigator.of(ctx).pop();
//               }),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _submit() async {
//     if (!_formKey.currentState.validate()) {
//       // Invalid!
//       return;
//     }
//     FocusScope.of(context).unfocus();
//     _formKey.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       // Log user in
//       await Provider.of<Auth>(context, listen: false)
//           .login(_authData['login'].trim(), _authData['password'].trim());
//     } on HttpException catch (error) {
//       var errorMessage = 'Ошибка авторизации. Повторите попытку позже.';
//       if (error.toString().contains('WRONG_PASSWORD')) {
//         errorMessage = 'Неверный пароль.';
//       } else if (error.toString().contains('USER_DOES_NOT_EXIST')) {
//         errorMessage = 'Пользователя с таким именем не существует.';
//       }
//       _showErrorDialog(errorMessage);
//     } catch (error) {
//       const errorMessage =
//           'Невозможно выполнить авторизацию. Повторите попытку позже.';
//       _showErrorDialog(errorMessage);
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   bool validateEmail(String value) {
//     Pattern pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern, caseSensitive: false);
//     return regex.hasMatch(value) ? false : true;
//   }
//
//   Widget _buildTextFieldEmail(BuildContext context) {
//     return TextFormField(
//       focusNode: _loginFocusNode,
//       maxLength: 20,
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       decoration: const InputDecoration(
//         labelText: 'Логин',
//       ),
//       onFieldSubmitted: (_) {
//         FocusScope.of(context).requestFocus(_passwordFocusNode);
//       },
//       validator: (value) {
//         if (value.isEmpty || validateEmail(value)) {
//           return 'Неверный email';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _authData['login'] = value;
//       },
//       onChanged: (text) {
//         setState(() {
//           text.isEmpty ? _loginFieldHasData = false : _loginFieldHasData = true;
//         });
//       },
//     );
//   }
//
//   Widget _buildTextFieldPassword(BuildContext context) {
//     return TextFormField(
//       maxLength: 20,
//       focusNode: _passwordFocusNode,
//       obscureText: true,
//       decoration: const InputDecoration(
//         labelText: 'Пароль',
//       ),
//       textInputAction: TextInputAction.done,
//       validator: (value) {
//         if (value.isEmpty || value.length < 5) {
//           return 'Пароль слишком короткий';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _authData['password'] = value;
//       },
//       onChanged: (text) {
//         setState(() {
//           text.isEmpty ? _pwdFieldHasData = false : _pwdFieldHasData = true;
//         });
//       },
//     );
//   }
//
//   Widget _buildAuthButton(BuildContext context) {
//     return Container(
//       alignment: Alignment.bottomRight,
//       margin: const EdgeInsets.only(top: 10),
//       child: MaterialButton(
//         elevation: 2,
//         disabledColor: Theme.of(context).disabledColor,
//         disabledTextColor: Theme.of(context).textTheme.button.color,
//         textColor: Theme.of(context).textTheme.headline5.color,
//         color: Theme.of(context).accentColor,
//         child: _isLoading
//             ? const SizedBox(
//                 height: 22.0,
//                 width: 22.0,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                 ),
//               )
//             : const Text(
//                 'ВХОД',
//                 style: TextStyle(fontSize: 15),
//               ),
//         shape: const StadiumBorder(),
//         onPressed: _pwdFieldHasData && _loginFieldHasData ? _submit : null,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         primaryColor: kAccentThemeColor,
//         accentColor: kAccentThemeColor,
//       ),
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 const Text(
//                   'Авторизация',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
//                 ),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 _buildTextFieldEmail(context),
//                 _buildTextFieldPassword(context),
//                 _buildAuthButton(context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              child: const Text('ОК'),
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(ctx).pop();
              }),
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
