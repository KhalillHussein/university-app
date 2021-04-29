import 'package:flutter/material.dart';

Future<T> showBottomRoundDialog<T>({
  @required BuildContext context,
  @required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => child,
  );
}
