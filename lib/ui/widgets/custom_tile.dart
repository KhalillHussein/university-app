import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final Widget trailing;
  final Color color;
  final EdgeInsets contentPadding;
  final Function onTap;

  CustomTile({
    this.icon,
    this.color,
    @required this.title,
    @required this.onTap,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 7.0),
    this.trailing,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: contentPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Icon(
                    icon,
                    color: Theme.of(context).iconTheme.color,
                    size: 28,
                  ),
                ),
              Expanded(child: title),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: trailing,
                ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
