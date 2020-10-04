import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../pages/account.dart';
import '../pages/authorization.dart';

class AuthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, authData, _) =>
          authData.isAuth ? AccountPage() : AuthorizationPage(),
    );
  }
}
