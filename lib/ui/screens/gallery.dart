import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../util/index.dart';
import '../widgets/index.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> galleryItems;
  final int initialIndex;
  final PageController pageController;

  GalleryScreen({
    this.galleryItems,
    this.initialIndex,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: appBarHeight,
          backgroundColor: Colors.black54,
          elevation: 0.0,
          title: Text(
            '${_currentIndex + 1} из ${widget.galleryItems.length}',
          ),
        ),
        body: _buildGallery(widget.galleryItems),
      ),
    );
  }

  double appBarHeight = kToolbarHeight;

  void setOverlaysVisible() {
    if (appBarHeight != 0) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      setState(() {
        appBarHeight = 0;
      });
    } else {
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      setState(() {
        appBarHeight = kToolbarHeight;
      });
    }
  }

  Widget _buildGallery(List<String> imageList) {
    return GestureDetector(
      onTap: setOverlaysVisible,
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: _buildItem,
        itemCount: imageList.length,
        loadingBuilder: _loadingBuilder,
        onPageChanged: onPageChanged,
        pageController: widget.pageController,
      ),
    );
  }

  Widget _loadingBuilder(BuildContext context, ImageChunkEvent event) {
    return Center(
      child: SizedBox(
        width: 30.0,
        height: 30.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDarkAccentColor),
          value: event == null
              ? 0
              : event.cumulativeBytesLoaded / event.expectedTotalBytes,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      tightMode: true,
      filterQuality: FilterQuality.high,
      imageProvider: CachedNetworkImageProvider(item),
      initialScale: PhotoViewComputedScale.contained * 1.0,
      minScale: PhotoViewComputedScale.contained * 1.0,
      maxScale: PhotoViewComputedScale.covered * 1.4,
      errorBuilder: (ctx, _, __) => const Center(
        child: PlaceholderImage(
          height: 200,
          width: double.infinity,
        ),
      ),
      heroAttributes: PhotoViewHeroAttributes(tag: '$item$index'),
    );
  }
}
