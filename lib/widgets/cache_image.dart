import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../widgets/placeholder_image.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final Size size;

  CacheImage(this.url, this.size);

  static const Size _smallSize = Size(120, 220.0),
      _bigSize = Size(double.infinity, 300.0);

  factory CacheImage.teacher({String url}) {
    return CacheImage(url, _smallSize);
  }

  factory CacheImage.news({String url}) {
    return CacheImage(url, _bigSize);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      height: size.height,
      width: size.width,
      imageUrl: url,
      fit: BoxFit.cover,
      memCacheWidth: 512,
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
