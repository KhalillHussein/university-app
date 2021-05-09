import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'index.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final Size size;
  final BoxFit fit;
  final int cacheWidth;
  final Widget placeholder;

  const CacheImage(
    this.url, {
    this.size,
    this.fit,
    this.cacheWidth,
    this.placeholder,
  });

  static const Size _bigSize = Size(double.infinity, 209);

  static const Size _middleSize = Size(145, 200);

  static const Size _smallSize = Size(50, 50);

  factory CacheImage.lecturer(String url) {
    return CacheImage(
      url,
      size: _middleSize,
      fit: BoxFit.cover,
    );
  }

  factory CacheImage.avatar(String url) {
    return CacheImage(
      url,
      size: _smallSize,
      placeholder: Icon(Icons.person, size: 50, color: Colors.white12),
    );
  }

  factory CacheImage.news(String url) {
    return CacheImage(url, size: _bigSize, cacheWidth: 400);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      alignment: Alignment(0.0, -0.4),
      useOldImageOnUrlChange: true,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      height: size?.height ?? double.infinity,
      width: size?.width ?? double.infinity,
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      memCacheWidth: cacheWidth ?? 800,
      filterQuality: FilterQuality.high,
      placeholder: (context, url) => Container(
        height: size?.height ?? double.infinity,
        width: size?.width ?? double.infinity,
        color: Theme.of(context).canvasColor,
        child: placeholder ?? _loadingIndicator,
      ),
      errorWidget: (context, url, error) => PlaceholderImage(
        height: size?.height ?? double.infinity,
        width: size?.width ?? double.infinity,
      ),
    );
  }

  Widget get _loadingIndicator => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.grey),
          strokeWidth: 3.0,
        ),
      );
}
