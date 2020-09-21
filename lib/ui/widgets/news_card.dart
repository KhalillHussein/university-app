import 'package:flutter/material.dart';
import 'expandable.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/index.dart';
import 'cache_image.dart';

class BodyImages extends StatelessWidget {
  final List<String> images;

  BodyImages(this.images);

  List<Widget> _listImages() {
    List<Widget> imagesList = [];
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
              Container(
                width: 110,
                height: 204,
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
              Container(
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
              Container(
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
                      child: Stack(children: [
                        Row(
                          children: [
                            _listImages().elementAt(3),
                          ],
                        ),
                        IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  'еще \n${_listImages().length - 3} фото',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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

  Picture({this.imageUrl, this.imageList, this.index, this.imageConstructor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            open(context);
          },
          child: Hero(
            child: imageConstructor,
            tag: imageUrl,
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

  Body({
    this.id,
    this.introText,
    this.fullText,
    this.views,
  });

  Widget _buildCollapsed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        introText,
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildExpanded() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MarkdownBody(
        selectable: true,
        data: fullText,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            height: 1.5,
          ),
        ),
        onTapLink: (link) async {
          if (await canLaunch(link)) {
            await launch(link);
          } else {
            throw 'Could not launch $link';
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      // initialExpanded:PageStorage.of(context).readState(context, identifier: id) ?? false,
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExpandablePanel(
              collapsed: _buildCollapsed(),
              expanded: _buildExpanded(),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Builder(
                    builder: (context) {
                      var controller = ExpandableController.of(context);
                      return FlatButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        textColor:
                            Theme.of(context).accentTextTheme.button.color,
                        child: Text(
                          controller.expanded ? "СКРЫТЬ" : "ПОДРОБНЕЕ",
                          style: TextStyle(height: 1.5, letterSpacing: 0.9),
                        ),
                        onPressed: introText.isEmpty
                            ? null
                            : () {
                                controller.toggle();
                                // PageStorage.of(context).writeState(
                                //   context,
                                //   controller.value,
                                //   identifier: id,
                                // );
                              },
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10),
                //   child: Row(
                //     children: <Widget>[
                //       const Icon(CommunityMaterialIcons.eye_settings_outline),
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

  Head(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyText1.color,
          height: 1.5,
        ),
        overflow: TextOverflow.fade,
      ),
    );
  }
}
