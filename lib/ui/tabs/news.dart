import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) => ListViewPage<NewsRepository>(
        buildFunction: (BuildContext context, int index) {
          model.handleScrollWithIndex(index);
          return index >= model.itemCount
              ? BottomLoader<NewsRepository>()
              : _buildNewsCard(context, index);
        },
        itemCount:
            model.hasReachedMax() ? model.itemCount : model.itemCount + 1,
      ),
    );
  }

  Widget _buildNewsHeader(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Colors.blueGrey.withOpacity(0.2),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                'СКФ МТУСИ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, int index) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) {
        final News news = model.news[index];
        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildNewsHeader(context, news.getDate),
              ),
              Head(news.title),
              if (news.images.isNotEmpty) BodyImages(news.images),
              if (news.images.isEmpty) const SizedBox(height: 10),
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
