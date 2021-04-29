import 'package:flutter/material.dart';

import 'package:big_tip/big_tip.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigTip(
        title: const Text('An error occurred'),
        subtitle: const Text('This page is not available'),
        action: const Text('GO BACK'),
        actionCallback: () => Navigator.pop(context),
        child: const Icon(Icons.error_outline),
      ),
    );
  }
}
