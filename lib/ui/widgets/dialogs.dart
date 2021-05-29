import 'package:flutter/material.dart';

Future<T> showBottomDialog<T>({
  @required BuildContext context,
  bool isDismissible = true,
  bool enableDrag = true,
  @required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (context) => child,
  );
}
