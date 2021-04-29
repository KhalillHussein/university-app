import 'package:flutter/material.dart';

import 'package:row_item/row_item.dart';

class RowText extends StatelessWidget {
  final String title, description;

  const RowText(
    this.title,
    this.description, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowItem.text(
      title,
      description,
      maxLines: 4,
      titleStyle: Theme.of(context).textTheme.bodyText2,
      descriptionStyle: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Theme.of(context).textTheme.caption.color,
          ),
    );
  }
}
