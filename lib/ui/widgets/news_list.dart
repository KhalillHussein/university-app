import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../models/news.dart';
import 'news_card.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (ctx, model, _) => ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        // key: PageStorageKey("NewsList"),
        addAutomaticKeepAlives: false,
        itemCount: model.itemCount,
        itemBuilder: _buildNewsCard,
      ),
    );
  }

  Widget _buildNewsHeader(String date) {
    return ListTile(
      leading: CircleAvatar(),
      title: const Text(
        'СКФ МТУСИ',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(date),
    );
  }

  Widget _buildNewsCard(BuildContext context, int index) {
    return Consumer<NewsProvider>(builder: (ctx, model, _) {
      final News news = model.news[index];
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
            _buildNewsHeader(news.getDate),
            Head(news.title),
            if (news.images.isNotEmpty) BodyImages(news.images),
            Body(
              id: news.id,
              introText: news.introText,
              fullText: news.fullText,
              views: news.views,
            ),
          ],
        ),
      );
    });
  }
}
