import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/news_provider.dart';
import '../widgets/news_list.dart';
import '../widgets/reusable_widgets.dart';
import '../pages/error.dart';

class NewsTab extends StatelessWidget {
  Future<void> _refreshNews(BuildContext context) async {
    await Provider.of<NewsProvider>(context, listen: false).fetchAndSetResult();
  }

  Widget _buildFuture(provider) {
    print('!call_reload');
    return FutureBuilder(
      future: provider.fetchAndSetResult(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          if (dataSnapshot.hasError) {
            print(dataSnapshot.error);
            return ErrorPage.news(context);
          } else {
            return RefreshIndicator(
              child: NewsList(),
              onRefresh: () => _refreshNews(context).catchError(
                (_) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(buildSnackBar(context));
                },
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild_news');
    return Consumer<NewsProvider>(
      builder: (ctx, newsData, _) => newsData.news.isEmpty
          ? _buildFuture(newsData)
          : RefreshIndicator(
              child: NewsList(),
              onRefresh: () => _refreshNews(context).catchError(
                (_) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(buildSnackBar(context));
                },
              ),
            ),
    );
  }
}
