import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mtusiapp/util/index.dart';

import '../models/index.dart';
import '../services/index.dart';
import 'index.dart';

/// Repository that holds news data.
class NewsRepository extends BaseRepository<NewsService> {
  final int _limit = 12;
  List<News> _news = [];
  int _pagesCount = 0;
  int _pageIndex = 1;

  NewsRepository(NewsService service) : super(service);

  @override
  Future<void> loadData() async {
    // Try to load the data using [ApiService]
    try {
      // Receives the data and parse it
      final newsResponse =
          await service.getNews(pageIndex: _pageIndex, limit: _limit);
      _pagesCount = newsResponse.data['result']['totalPages'];
      debugPrint(newsResponse.data['result']['page']
          .toString()); //showing current page number
      for (final item in newsResponse.data['result']['docs']) {
        _news.add(News.fromJson(item));
      }
      _pageIndex++;
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('[PARSER ERROR]');
    }
  }

  @override
  Future<void> refreshData() async {
    // Try to load the data using [ApiService]
    try {
      // Receives the data and parse it
      final newsResponse = await service.getNews(pageIndex: 1, limit: _limit);
      _news = [
        for (final item in newsResponse.data['result']['docs'])
          News.fromJson(item)
      ];
      _pageIndex = 1;
      _pageIndex++;
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('[PARSER ERROR]');
    }
  }

  bool hasReachedMax() {
    return _pageIndex >= _pagesCount;
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % _limit == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ _limit;
    if (requestMoreData && pageToRequest + 1 >= _pageIndex && !loadingFailed) {
      loadData();
    }
  }

  List<News> get news => _news;

  int get itemCount => _news?.length;
}
