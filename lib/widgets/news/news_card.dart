import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/photo_view_screen.dart';
import '../cache_image.dart';

class NewsCard extends StatelessWidget {
  final List<dynamic> images;
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
          Title(
            title: title,
            images: images,
          ),
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

//Image class
class Images extends StatelessWidget {
  final String imageUrl;

  Images({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PhotoViewScreen.routeName, arguments: {
              'imageUrl': imageUrl,
            });
          },
          child: Hero(
            child: CacheImage.news(url: imageUrl),
            tag: imageUrl,
          ),
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
  final List<dynamic> images;

  Title({this.title, this.images});
  List<Widget> _listImages() {
    List<Widget> imagesList = [];
    for (var imageUrl in images) {
      imagesList.add(
        Images(imageUrl: 'http://80.78.248.203:3064/img/news/$imageUrl'),
      );
    }
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyText1.color,
              height: 1.5,
            ),
            overflow: TextOverflow.fade,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(children: _listImages()),
          ),
        ],
      ),
    );
  }
}
