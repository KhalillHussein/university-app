import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:share/share.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../util/index.dart';
import '../views/screens/index.dart';
import 'index.dart';

class NewsCard extends StatelessWidget {
  final News item;

  const NewsCard(this.item, Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Header(date: item.getDate, id: item.id),
          Separator.spacer(space: 15),
          _Title(item.title),
          if (item.images.isNotEmpty) _BodyImages(item.images),
          if (item.images.isEmpty) Separator.spacer(space: 10),
          _Body(
            id: item.id,
            introText: item.introText,
            fullText: item.fullText,
            views: item.views,
            shareImage: item.images.isNotEmpty ? item.images.first : '',
            shareTitle: item.title,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String date;
  final String id;

  const _Header({Key key, @required this.date, @required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
      child: Consumer<AuthRepository>(
        builder: (ctx, model, _) => Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: k24dp,
                  child: ClipOval(
                      child: Image.asset(
                    'assets/images/avatar.png',
                  )),
                ),
                Separator.spacer(space: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'СКФ МТУСИ',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black87
                                    : Colors.white.withOpacity(0.9),
                          ),
                      textScaleFactor: 1.1,
                    ).scalable(),
                    Separator.spacer(space: 3),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.caption,
                      textScaleFactor: 1.15,
                    ).scalable(),
                  ],
                ),
              ],
            ),
            if (model.user?.getUserPosition() == Positions.admin)
              Positioned(
                top: -15,
                right: 0,
                child: Consumer2<NewsRepository, NewsCreateRepository>(
                  builder: (ctx, model, model2, _) => IconButton(
                    splashRadius: 15,
                    tooltip: 'Удалить',
                    icon: Icon(
                      MdiIcons.trashCanOutline,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () => showModalDialog(
                      context,
                      title: 'Удалить эту новость?',
                      content:
                          'Новость будет удалена из списка без возможности восстановления.',
                      onPressed: model2.isLoading
                          ? null
                          : () async {
                              await model2.deleteData(id);
                              if (model2.loadingFailed) {
                                _showSnackBar(context, model2.errorMessage);
                              } else {
                                model.deleteItem(id);
                                Navigator.of(ctx).pop();
                              }
                            },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).errorColor,
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).primaryColor,
              ),
              Separator.spacer(),
              Expanded(
                child: Text(
                  message,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

class _BodyImages extends StatelessWidget {
  final List<String> images;

  const _BodyImages(this.images);

  List<Widget> _listImages() {
    return [
      for (int i = 0; i < images.length; i++)
        _Picture(
          imageConstructor: CacheImage.news(
            images[i],
          ),
          imageUrl: images[i],
          imageList: images,
          index: i,
        ),
    ];
  }

  Widget imageLayout(Size size) {
    return Column(
      children: [
        if (_listImages().length == 3)
          Row(
            children: [
              _listImages().first,
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.3,
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
                height: size.height * 0.13,
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
                height: size.height * 0.13,
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
                              ).scalable(),
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
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: imageLayout(size),
    );
  }
}

//Image class
class _Picture extends StatelessWidget {
  final String imageUrl;
  final int index;
  final List<String> imageList;
  final CacheImage imageConstructor;

  const _Picture({
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
        fullscreenDialog: true,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String id;
  final String introText;
  final String fullText;
  final int views;
  final String shareTitle;
  final String shareImage;

  const _Body(
      {this.id,
      @required this.introText,
      @required this.fullText,
      this.views,
      this.shareImage,
      this.shareTitle});

  Widget _buildCollapsed(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        introText,
        maxLines: 3,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              height: 1.3,
              letterSpacing: 0.15,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white.withOpacity(0.9),
            ),
        textScaleFactor: 0.85,
        overflow: TextOverflow.ellipsis,
      ).scalable(),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MarkdownBody(
        shrinkWrap: false,
        selectable: true,
        fitContent: false,
        data: fullText,
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.subtitle1.copyWith(
                height: 1.3,
                letterSpacing: 0.15,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white.withOpacity(0.9),
              ),
          textScaleFactor: 0.85,
        ),
        onTapLink: (_, link, __) => showUrl(link),
      ).scalable(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      key: Key(id),
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExpandablePanel(
              collapsed: _buildCollapsed(context),
              expanded: _buildExpanded(context),
            ),
            Separator.spacer(),
            Separator.divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
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
                          textScaleFactor: 1.4,
                        ).scalable(),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    size: 22,
                  ),
                  splashRadius: 20,
                  tooltip: 'Поделиться',
                  color: Theme.of(context).textTheme.caption.color,
                  onPressed: () => Share.share(
                    fullText,
                    subject: shareTitle,
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
class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white.withOpacity(0.9),
            ),
        textScaleFactor: 1.25,
      ).scalable(),
    );
  }
}
