import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/account_screen.dart';
import '../screens/auth_screen.dart';
import '../providers/auth.dart';

class CheckAuthStatus extends StatelessWidget {
//  Widget _buildFuture(Auth authData) {
//    return FutureBuilder(
//      future: authData.tryAutoLogin(),
//      builder: (ctx, authResultSnapshot) =>
//          authResultSnapshot.connectionState == ConnectionState.waiting
//              ? Center(child: CircularProgressIndicator())
//              : AuthScreen(),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, authData, _) =>
          authData.isAuth ? AccountScreen() : AuthScreen(),
    );
  }
}
