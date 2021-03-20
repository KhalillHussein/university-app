import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'index.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final Size size;
  final BoxFit fit;

  const CacheImage(this.url, this.size, this.fit);

  static const Size _smallSize = Size(120, 220.0),
      _bigSize = Size(double.infinity, 209);

  factory CacheImage.teacher({String url}) {
    return CacheImage(url, _smallSize, BoxFit.cover);
  }

  factory CacheImage.news({String url}) {
    return CacheImage(url, _bigSize, BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      alignment: Alignment(0.0, -0.8),
      useOldImageOnUrlChange: true,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      height: size.height,
      width: size.width,
      imageUrl: url,
      fit: fit,
      memCacheWidth: 400,
      placeholder: (context, url) => Container(
        height: size.height,
        width: size.width,
        color: Theme.of(context).canvasColor,
        child: const Center(
          child: CircularProgressIndicator(
            //  backgroundColor: Theme.of(context).canvasColor,
            valueColor: AlwaysStoppedAnimation(Colors.grey),
            strokeWidth: 3.0,
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
