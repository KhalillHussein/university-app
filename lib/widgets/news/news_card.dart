import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/photo_view_screen.dart';
import '../cache_image.dart';

class NewsCard extends StatelessWidget {
  final List<String> images;
  final String id;
  final String title;
  final String introText;
  final String fullText;
  final int views;
  final DateTime date;
  final Key key;

  NewsCard(
      {this.id,
      @required this.images,
      @required this.title,
      @required this.introText,
      @required this.fullText,
      @required this.views,
      @required this.date,
      this.key});

  Widget _buildNewsHeader() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage('http://www.skf-mtusi.ru/images/logo_skf.png'),
      ),
      title: const Text(
        'СКФ МТУСИ',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${toBeginningOfSentenceCase(DateFormat.yMMMMd('en_US').format(date))}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNewsHeader(),
          Title(title),
          BodyImages(images),
          Body(
            id: id,
            introText: introText,
            fullText: fullText,
            views: views,
          ),
        ],
      ),
    );
  }
}

class BodyImages extends StatelessWidget {
  final List<String> images;

  BodyImages(this.images);
  //
  // List<Widget> _listImages() {
  //   List<Widget> imagesList = [];
  //   for (var imageUrl in images) {
  //     imagesList.add(
  //       Image(imageUrl: imageUrl, imageList: images),
  //     );
  //   }
  //   return imagesList;
  // }

  List<Widget> _listImages() {
    List<Widget> imagesList = [];
    for (int i = 0; i < images.length; i++) {
      imagesList.add(
        Image(
          imageUrl: images[i],
          imageList: images,
          index: i,
        ),
      );
    }
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        children: [
          if (_listImages().length == 3)
            Row(
              children: [
                _listImages().first,
                Container(
                  width: 120,
                  height: 304,
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
                  height: 110,
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
                  height: 110,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: _listImages().getRange(1, 3).toList(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            child: Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  'еще \n${_listImages().length - 3} фото',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

//Image class
class Image extends StatelessWidget {
  final String imageUrl;
  final int index;
  final List<String> imageList;

  Image({this.imageUrl, this.imageList, this.index});

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
            child: CacheImage.news(url: imageUrl),
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
        builder: (context) => PhotoViewScreen(
          galleryItems: imageList,
          initialIndex: index,
        ),
      ),
    );
  }
}

//Body class
class Body extends StatelessWidget {
  final String id;
  final String introText;
  final String fullText;
  final int views;

  Body({this.id, this.introText, this.fullText, this.views});

  Widget buildCollapsed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            introText,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget buildExpanded() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            text: fullText,
            style: TextStyle(height: 1.5),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded:
          PageStorage.of(context).readState(context, identifier: id) ?? false,
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expandable(
              collapsed: buildCollapsed(),
              expanded: buildExpanded(),
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
                            style: TextStyle(height: 1.5)),
                        onPressed: introText.isEmpty
                            ? null
                            : () {
                                controller.toggle();
                                PageStorage.of(context).writeState(
                                  context,
                                  controller.value,
                                  identifier: id,
                                );
                              },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: <Widget>[
                      const Icon(CommunityMaterialIcons.eye_settings_outline),
                      const SizedBox(width: 5),
                      Text('$views')
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Title class
class Title extends StatelessWidget {
  final String title;

  Title(this.title);

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
