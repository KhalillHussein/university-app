// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
//
// import '../widgets/placeholder_image.dart';
//
// class PhotoViewScreen extends StatefulWidget {
//   static const routeName = '/photo-viewer';
//
//   @override
//   _PhotoViewScreenState createState() => _PhotoViewScreenState();
// }
//
// class _PhotoViewScreenState extends State<PhotoViewScreen>
//     with SingleTickerProviderStateMixin {
//   bool _showAppBar;
//   AnimationController _controller;
//   Animation _animation;
//
//   @override
//   void initState() {
//     _showAppBar = true;
//     FlutterStatusbarcolor.setStatusBarColor(Colors.black87, animate: true);
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 110),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
//     _controller.forward();
//     _controller.addListener(() {
//       print(_animation.value);
//       setState(() {});
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _controller.removeListener(() {});
//     SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//     FlutterStatusbarcolor.setStatusBarColor(Colors.black26, animate: true);
//     super.dispose();
//   }
//
//   void _toggleAppBarVisibility() {
//     _showAppBar = !_showAppBar;
//     _showAppBar ? _controller.forward() : _controller.reverse();
//     _showAppBar
//         ? Timer(
//             Duration(milliseconds: 40),
//             () => SystemChrome.setEnabledSystemUIOverlays(
//                 [SystemUiOverlay.top, SystemUiOverlay.bottom]))
//         : Timer(
//             Duration(milliseconds: 190),
//             () => SystemChrome.setEnabledSystemUIOverlays(
//                 [SystemUiOverlay.bottom]));
//   }
//
//   Widget _buildAppBar() {
//     return PreferredSize(
//       preferredSize: Size(double.infinity, kToolbarHeight),
//       child: AnimatedOpacity(
//         opacity: _animation.value,
//         duration: _controller.duration,
//         child: AppBar(
//             centerTitle: true,
//             backgroundColor: Colors.black54,
//             elevation: 0.0,
//             title: Text('1 из 1')),
//       ),
//     );
//   }
//
//   Widget _buildImage(String imageUrl) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           _toggleAppBarVisibility();
//         },
//         child: PhotoView(
//           tightMode: true,
//           heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
//           filterQuality: FilterQuality.high,
//           imageProvider: CachedNetworkImageProvider(imageUrl),
//           initialScale: PhotoViewComputedScale.contained * 1.0,
//           minScale: PhotoViewComputedScale.contained * 1.0,
//           maxScale: PhotoViewComputedScale.covered * 1.2,
//           loadFailedChild: PlaceholderImage(
//             height: 200,
//             width: double.infinity,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Map args = ModalRoute.of(context).settings.arguments as Map;
//     return Theme(
//       data: ThemeData.dark(),
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         extendBody: true,
//         extendBodyBehindAppBar: true,
//         appBar: _buildAppBar(),
//         body: _buildImage(args['imageUrl']),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../widgets/placeholder_image.dart';

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
    FlutterStatusbarcolor.setStatusBarColor(Colors.black87, animate: true);
    super.initState();
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black26, animate: true);
    widget.pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildGallery(List<String> imageList) {
    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: _buildItem,
        itemCount: imageList.length,
        loadingBuilder: _loadingBuilder,
        onPageChanged: onPageChanged,
        pageController: widget.pageController,
        loadFailedChild: PlaceholderImage(
          height: 200,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _loadingBuilder(BuildContext context, ImageChunkEvent event) {
    return Center(
      child: Container(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
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
      maxScale: PhotoViewComputedScale.covered * 1.2,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
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
}
