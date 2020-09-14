import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    @required this.child,
    @required this.value,
    this.color,
  });

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: child,
          alignment: Alignment.centerLeft,
        ),
        Positioned(
          right: 1,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color != null ? color : Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}