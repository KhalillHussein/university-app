import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mtusiapp/providers/index.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart';
import '../../../repositories/index.dart';
import '../../../ui/widgets/index.dart';

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
      builder: (ctx, model, _) => BasicPage(
        title: 'Новости',
      ).paginatedTab<News, NewsRepository>(
        context,
        (context, item, index) => NewsCard(
          item,
          Key(item.id),
        ),
        _pagingController..value = model.pagingState,
        placeholder: NewsPlaceholder(),
      ),
    );
  }
}
