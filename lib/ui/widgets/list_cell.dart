import 'package:flutter/material.dart';

import 'package:row_collection/row_collection.dart';

import '../../util/extensions.dart';

/// Widget similar to [ListTile] with custom theme
/// and constructors.
class ListCell extends StatelessWidget {
  final Widget leading, trailing;
  final String title, subtitle;
  final VoidCallback onTap;
  final EdgeInsets contentPadding;
  final bool dense;

  const ListCell({
    Key key,
    this.leading,
    this.trailing,
    @required this.title,
    this.subtitle,
    this.onTap,
    this.contentPadding,
    this.dense = false,
  }) : super(key: key);

  /// Builds a [ListCell] using a [IconData] object as the leading
  /// widget.
  factory ListCell.icon({
    Key key,
    @required IconData icon,
    Widget trailing,
    @required String title,
    String subtitle,
    VoidCallback onTap,
    double iconSize,
    EdgeInsets contentPadding,
    bool dense = false,
  }) {
    return ListCell(
      key: key,
      leading: Transform.translate(
        offset: Offset(0, 4),
        child: Icon(icon, size: iconSize ?? 25),
      ),
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      contentPadding: contentPadding,
      dense: dense,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ).scalable(),
          if (subtitle != null) Separator.spacer(space: 4),
        ],
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: Theme.of(context).textTheme.caption,
              textScaleFactor: 1.05,
            ).scalable(),
      trailing: onTap != null && trailing == null
          ? Icon(Icons.chevron_right)
          : trailing,
      contentPadding: contentPadding,
      onTap: onTap,
      dense: dense,
    );
  }
}

/// Text widget with custom theme, generally used as a
/// trailing widget inside [ListCell].
class TrailingText extends StatelessWidget {
  final String data;

  const TrailingText(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Theme.of(context).textTheme.caption.color,
          ),
    );
  }
}
