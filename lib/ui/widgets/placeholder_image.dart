import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final double height;
  final double width;

  const PlaceholderImage({
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Icon(
          Icons.photo,
          color: Theme.of(context).disabledColor,
          size: 80.0,
        ),
      ),
    );
  }
}
