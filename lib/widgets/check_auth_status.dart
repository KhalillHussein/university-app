import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/account_screen.dart';
import '../screens/auth_screen.dart';
import '../providers/auth.dart';

class CheckAuthStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, authData, _) =>
          authData.isAuth ? AccountScreen() : AuthScreen(),
    );
  }
}
