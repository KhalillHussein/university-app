import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        appBar: AppBar(
          centerTitle: true,
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

  Widget _buildGallery(List<String> imageList) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: _buildItem,
      itemCount: imageList.length,
      loadingBuilder: _loadingBuilder,
      onPageChanged: onPageChanged,
      pageController: widget.pageController,
    );
  }

  Widget _loadingBuilder(BuildContext context, ImageChunkEvent event) {
    return Center(
      child: SizedBox(
        width: 30.0,
        height: 30.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDarkPrimaryColor),
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
