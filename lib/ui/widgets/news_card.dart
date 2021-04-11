import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/index.dart';
import '../screens/index.dart';
import 'index.dart';

class BodyImages extends StatelessWidget {
  final List<String> images;

  const BodyImages(this.images);

  List<Widget> _listImages() {
    final List<Widget> imagesList = [];
    for (int i = 0; i < images.length; i++) {
      imagesList.add(
        Picture(
          imageConstructor: CacheImage.news(
            url: images[i],
          ),
          imageUrl: images[i],
          imageList: images,
          index: i,
        ),
      );
    }
    return imagesList;
  }

  Widget imageLayout() {
    return Column(
      children: [
        if (_listImages().length == 3)
          Row(
            children: [
              _listImages().first,
              SizedBox(
                width: 110,
                height: 211,
                child: Column(
                  children: _listImages().getRange(1, 3).toList(),
                ),
              )
            ],
          ),
        if (_listImages().length < 3)
          Row(
            children: _listImages(),
          ),
        if (_listImages().length == 4)
          Column(
            children: [
              Row(
                children: [
                  _listImages().first,
                ],
              ),
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: _listImages().getRange(1, 4).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (_listImages().length > 4)
          Column(
            children: [
              Row(
                children: [
                  _listImages().first,
                ],
              ),
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: _listImages().getRange(1, 3).toList(),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.78),
                                BlendMode.darken),
                            child: Row(
                              children: [
                                _listImages().elementAt(3),
                              ],
                            ),
                          ),
                          IgnorePointer(
                            child: Center(
                              child: Text(
                                'еще \n${_listImages().length - 3} фото',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: imageLayout(),
    );
  }
}

//Image class
class Picture extends StatelessWidget {
  final String imageUrl;
  final int index;
  final List<String> imageList;
  final CacheImage imageConstructor;

  const Picture({
    @required this.imageUrl,
    @required this.imageList,
    @required this.index,
    this.imageConstructor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GestureDetector(
          onTap: () {
            open(context);
          },
          child: Hero(
            tag: '$imageUrl$index',
            child: imageConstructor,
          ),
        ),
      ),
    );
  }

  void open(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(
          galleryItems: imageList,
          initialIndex: index,
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final String id;
  final String introText;
  final String fullText;
  final int views;

  const Body({
    this.id,
    @required this.introText,
    @required this.fullText,
    this.views,
  });

  Widget _buildCollapsed(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        introText,
        maxLines: 3,
        textAlign: TextAlign.start,
        style: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ).bodyText2.copyWith(height: 1.4),
        textScaleFactor: 1.05,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MarkdownBody(
        selectable: true,
        data: fullText,
        styleSheet: MarkdownStyleSheet(
          p: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).bodyText2.copyWith(height: 1.4),
          textScaleFactor: 1.05,
        ),
        onTapLink: (_, link, __) => showUrl(link),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExpandablePanel(
              collapsed: _buildCollapsed(context),
              expanded: _buildExpanded(context),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              thickness: 1.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Builder(
                    builder: (context) {
                      final controller = ExpandableController.of(context);
                      return TextButton(
                        onPressed:
                            fullText.isEmpty ? null : () => controller.toggle(),
                        child: Text(
                          controller.expanded ? "СКРЫТЬ" : "ПОДРОБНЕЕ",
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).overline.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.5,
                        ),
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10),
                //   child: Row(
                //     children: <Widget>[
                //       const Icon(Icons.share_outlined),
                //       const SizedBox(width: 5),
                //       Text('$views')
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Title class
class Head extends StatelessWidget {
  final String title;

  const Head(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ).headline6.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white,
            ),
      ),
    );
  }
}
