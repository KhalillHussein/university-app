import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;
  final double rightPosition;
  final BorderRadiusGeometry borderRadius;

  const Badge({
    @required this.child,
    @required this.value,
    this.rightPosition = 10,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: child,
        ),
        Positioned(
          right: rightPosition,
          top: 13,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              // borderRadius: borderRadius ?? BorderRadius.circular(10.0),
              color: color ?? Theme.of(context).accentColor,
              shape: BoxShape.circle,
            ),
            // constraints: BoxConstraints(
            //   minWidth: 15,
            //   minHeight: 15,
            // ),
            child: Padding(
              padding: const EdgeInsets.all(0.2),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
                textScaleFactor: 0.7,
              ),
            ),
          ),
        )
      ],
    );
  }
}
