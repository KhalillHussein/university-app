import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const Badge({
    @required this.child,
    @required this.value,
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
          right: 1,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color ?? Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}
