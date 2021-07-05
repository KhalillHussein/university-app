import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import 'index.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final Size size;
  final BoxFit fit;

  final Widget placeholder;

  const CacheImage(
    this.url, {
    this.size,
    this.fit,
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
      placeholder: _AvatarPlaceholder(),
    );
  }

  factory CacheImage.news(String url) {
    return CacheImage(url, size: _bigSize);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageQualityProvider>(
      builder: (ctx, quality, _) => CachedNetworkImage(
        alignment: Alignment(0.0, -0.4),
        useOldImageOnUrlChange: true,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.height * 0.3,
        width: size?.width ?? double.infinity,
        imageUrl: url,
        fit: fit ?? BoxFit.cover,
        memCacheWidth: quality.imageCacheWidth(),
        filterQuality: FilterQuality.high,
        progressIndicatorBuilder: (ctx, url, downloadProgress) => Container(
          height: size?.height ?? double.infinity,
          width: size?.width ?? double.infinity,
          color: Theme.of(context).canvasColor,
          child: Center(
            child: placeholder ??
                CircularProgressIndicator(
                  value: downloadProgress.progress,
                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                  strokeWidth: 3.5,
                ),
          ),
        ),
        errorWidget: (context, url, error) => PlaceholderImage(
          height: size?.height ?? double.infinity,
          width: size?.width ?? double.infinity,
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(MdiIcons.accountTie,
        size: 50, color: Theme.of(context).dividerColor);
  }
}
