import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final double height;
  final double width;

  PlaceholderImage({
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
          color: Colors.white30,
          size: 84.0,
        ),
      ),
    );
  }
}
