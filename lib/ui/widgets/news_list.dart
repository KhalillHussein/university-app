import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import 'news_card.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (ctx, newsData, _) => ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        // key: PageStorageKey("NewsList"),
        addAutomaticKeepAlives: false,
        itemCount: newsData.itemCount,
        itemBuilder: (ctx, index) {
          final newsItem = newsData.news[index];
          return NewsCard(
            key: ValueKey(newsItem.id),
            id: newsItem.id,
            title: newsItem.title,
            images: newsItem.images,
            introText: newsItem.introText,
            fullText: newsItem.fullText,
            views: newsItem.views,
            date: newsItem.date,
          );
        },
      ),
    );
  }
}
