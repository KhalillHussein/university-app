import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/repositories/news_edit.dart';

import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

import '../../util/index.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReloadableTab<NewsRepository>(
      title: 'Новости',
      placeholder: NewsPlaceholder(),
      body: Scrollbar(
        thickness: 3.0,
        child: Consumer<NewsRepository>(
          builder: (ctx, model, _) => ScrollablePositionedList.builder(
            addAutomaticKeepAlives: false,
            itemCount:
                model.hasReachedMax() ? model.itemCount : model.itemCount + 1,
            itemBuilder: (BuildContext context, int index) {
              model.handleScrollWithIndex(index);
              return index >= model.itemCount
                  ? BottomLoader<NewsRepository>()
                  : _buildNewsCard(context, index, model);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, int index, NewsRepository model) {
    final News news = model.news[index];
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
          _buildNewsHeader(context, news.getDate, news.id),
          Separator.spacer(space: 15),
          Head(news.title),
          if (news.images.isNotEmpty) BodyImages(news.images),
          if (news.images.isEmpty) Separator.spacer(space: 10),
          Body(
            id: news.id,
            introText: news.introText,
            fullText: news.fullText,
            views: news.views,
            shareImage: news.images.isNotEmpty ? news.images.first : '',
            shareTitle: news.title,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsHeader(BuildContext context, String date, [String id]) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
      child: Consumer<AuthRepository>(
        builder: (ctx, model, _) => Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blueGrey.withOpacity(0.2),
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
            if (model.getUserPosition() == Positions.admin)
              Positioned(
                top: -15,
                right: 0,
                child: IconButton(
                  splashRadius: 15,
                  tooltip: 'Удалить',
                  icon: Icon(
                    MdiIcons.trashCanOutline,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () => _showDialog(context, id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        content: const Text(
          'Удалить эту новость?',
        ).scalable(),
        actions: <Widget>[
          TextButton(
            style:
                TextButton.styleFrom(primary: Theme.of(context).disabledColor),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'ОТМЕНА',
            ).scalable(),
          ),
          Consumer2<NewsRepository, NewsEditRepository>(
            builder: (ctx, model, model2, _) => TextButton(
              onPressed: () async {
                await model2.deleteData(id);
                if (model2.postingFailed) {
                  _showSnackBar(context, model.errorMessage);
                }
                Navigator.of(ctx).pop();
                model.refreshData();
              },
              child: const Text(
                'ОК',
              ).scalable(),
            ),
          ),
        ],
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
