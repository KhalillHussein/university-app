import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/models/index.dart';
import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../repositories/news_create.dart';
import '../../ui/widgets/index.dart';
import '../../util/index.dart';

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final PagingController<int, News> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      context.read<NewsRepository>().pageIndex = pageKey;
      context.read<NewsRepository>().loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) => ReloadablePaginatedTab<News, NewsRepository>(
        title: 'Новости',
        placeholder: NewsPlaceholder(),
        pagingController: _pagingController..value = model.pagingState,
        itemBuilder: (context, item, index) => NewsCard(
          item,
          Key(item.id),
        ),
      ),
    );
  }
}

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
          _buildNewsHeader(context, item.getDate, item.id),
          Separator.spacer(space: 15),
          Head(item.title),
          if (item.images.isNotEmpty) BodyImages(item.images),
          if (item.images.isEmpty) Separator.spacer(space: 10),
          Body(
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
            if (model.getUserPosition() == Positions.admin)
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
                              }
                              model.deleteItem(id);
                              Navigator.of(ctx).pop();
                              // model.refreshData();
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
