import 'package:flutter/material.dart';

import 'package:big_tip/big_tip.dart';
import '../../../util/extensions.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigTip(
        title: const Text('An error occurred').scalable(),
        subtitle: const Text('This page is not available').scalable(),
        action: const Text('GO BACK').scalable(),
        actionCallback: () => Navigator.pop(context),
        child: const Icon(Icons.error_outline),
      ),
    );
  }
}
