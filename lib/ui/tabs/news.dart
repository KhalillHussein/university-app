import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/news.dart';
import '../../repositories/news.dart';
import '../../ui/widgets/custom_page.dart';
import '../../ui/widgets/news_card.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('rebuild_news');
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) => ListViewPage<NewsRepository>(
        itemCount: model.newsCount,
        buildFunction: _buildNewsCard,
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
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) {
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
      },
    );
  }
}
