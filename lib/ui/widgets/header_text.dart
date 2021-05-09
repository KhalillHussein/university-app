import 'package:flutter/material.dart';

import '../../util/index.dart';

/// This widget is used in the 'Телефонный справочник' & 'Заказ справок' screens.
/// It categorizes items based on a theme.
class HeaderText extends StatelessWidget {
  final String text;
  final bool head;
  final Color color;

  const HeaderText(
    this.text, {
    Key key,
    this.head = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        top: head ? 16 : 0,
        left: 16,
        right: 90,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: color ?? Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
      ).scalable(),
    );
  }
}
