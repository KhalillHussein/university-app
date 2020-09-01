import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../widgets/placeholder_image.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final Size size;

  CacheImage(this.url, this.size);

  static const Size _smallSize = Size(110.0, 80.0),
      _bigSize = Size(double.infinity, 180.0);

  factory CacheImage.teacher({String url}) {
    return CacheImage(url, _smallSize);
  }

  factory CacheImage.news({String url}) {
    return CacheImage(url, _bigSize);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).canvasColor,
            valueColor: AlwaysStoppedAnimation(Colors.grey),
            strokeWidth: 2.0,
          ),
        ),
      ),
      errorWidget: (context, url, error) => PlaceholderImage(
        height: size.height,
        width: size.width,
      ),
    );
  }
}
