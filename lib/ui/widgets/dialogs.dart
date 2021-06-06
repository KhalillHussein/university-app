import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

import '../../util/extensions.dart';

Future<T> showBottomDialog<T>({
  @required BuildContext context,
  bool isDismissible = true,
  bool enableDrag = true,
  @required String title,
  EdgeInsetsGeometry padding = const EdgeInsets.all(10.0),
  @required List<Widget> children,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (context) => SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Separator.spacer(space: 25),
        if (title != null)
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
            textScaleFactor: 0.9,
          ).scalable(),
        if (title != null) Separator.spacer(space: 20),
        Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ]),
    ),
  );
}
