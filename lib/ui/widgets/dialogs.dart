import 'package:flutter/material.dart';

Future<T> showBottomRoundDialog<T>({
  @required BuildContext context,
  @required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => child,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(10.0),
        topRight: const Radius.circular(10.0),
      ),
    ),
  );
}
