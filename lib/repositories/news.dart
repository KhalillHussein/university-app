// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// import '../models/news.dart';
// import '../util/url.dart';
//
// import 'base_db.dart';
//
// /// Repository that holds news data.
// class NewsRepository extends BaseRepository {
//   List<News> _news;
//
//   @override
//   Future<void> loadData() async {
//     try {
//       final response = await http.get('${Url.newsUrl}/?limit=10&page=1');
//       final responseData = json.decode(response.body);
//       if (responseData['errors'] != null) {
//         receivedError();
//       }
//       final responseResult = responseData['result']['docs'];
//       _news = [for (final item in responseResult) News.fromJson(item)]
//         ..sort((a, b) => b.date.compareTo(a.date));
//       finishLoading();
//     } catch (_) {
//       receivedError();
//     }
//   }
//
//   List<News> get news => _news;
//
//   int get itemCount => _news?.length;
// }

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
//
// import '../models/index.dart';
// import '../services/index.dart';
// import 'index.dart';
//
// /// Repository that holds news data.
// class NewsRepository extends BaseRepository<NewsService> {
//   final List<News> _news = [];
//   int _pagesCount;
//   int _page = 1;
//   final List<int> _pageIndexes = [];
//
//   NewsRepository(NewsService service) : super(service);
//
//   @override
//   Future<void> loadData({int pageIndex = 1, int limit = 12}) async {
//     // Try to load the data using [ApiService]
//     try {
//       // Receives the data and parse it
//       final newsResponse =
//           await service.getNews(pageIndex: pageIndex, limit: limit);
//       _pagesCount = newsResponse.data['result']['totalPages'];
//       _page = newsResponse.data['result']['page'];
//       debugPrint(_page.toString());
//       if (!_pageIndexes.contains(_page)) {
//         for (final item in newsResponse.data['result']['docs']) {
//           _news.add(News.fromJson(item));
//         }
//         _pageIndexes.add(_page);
//       }
//       finishLoading();
//     } on DioError catch (_) {
//       receivedError(_.toString());
//     } catch (_) {
//       receivedError('[PARSER ERROR]');
//     }
//   }
//
//   ///Function that performs pagination
//   Future<void> nextPage() async {
//     if (loadingFailed) {
//       await loadData(pageIndex: _page);
//     } else {
//       await loadData(pageIndex: ++_page);
//     }
//   }
//
//   bool hasReachedMax() {
//     try {
//       return _pageIndexes.last >= _pagesCount;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   void handleScrollWithIndex(int index) {
//     final itemPosition = index + 1;
//     final requestMoreData = itemPosition % 12 == 0 && itemPosition != 0;
//     final pageToRequest = itemPosition ~/ 20;
//
//     if (requestMoreData && pageToRequest + 1 >= page) {
//       loadData();
//     }
//   }
//
//   List<News> get news => _news;
//
//   int get itemCount => _news?.length;
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/index.dart';
import '../services/index.dart';
import 'index.dart';

/// Repository that holds news data.
class NewsRepository extends BaseRepository<NewsService> {
  final List<News> _news = [];
  int _pagesCount;
  int _page = 1;
  int _pageIndex = 1;
  final List<int> _pageIndexes = [];

  NewsRepository(NewsService service) : super(service);

  @override
  Future<void> loadData({int pageIndex = 1, int limit = 12}) async {
    // Try to load the data using [ApiService]
    try {
      // Receives the data and parse it
      final newsResponse =
          await service.getNews(pageIndex: _pageIndex, limit: limit);
      _pageIndex += 1;
      _pagesCount = newsResponse.data['result']['totalPages'];
      _page = newsResponse.data['result']['page'];
      debugPrint(_page.toString());
      if (!_pageIndexes.contains(_page)) {
        for (final item in newsResponse.data['result']['docs']) {
          _news.add(News.fromJson(item));
        }
        _pageIndexes.add(_page);
      }
      finishLoading();
    } on DioError catch (_) {
      receivedError(_.toString());
    } catch (_) {
      receivedError('[PARSER ERROR]');
    }
  }

  ///Function that performs pagination
  Future<void> nextPage() async {
    if (loadingFailed) {
      await loadData(pageIndex: _page);
    } else {
      await loadData(pageIndex: ++_page);
    }
  }

  bool hasReachedMax() {
    try {
      return _pageIndexes.last >= _pagesCount;
    } catch (_) {
      return false;
    }
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 12 == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ 12;
    if (requestMoreData && pageToRequest + 1 >= _pageIndex) {
      loadData();
    }
  }

  List<News> get news => _news;

  int get itemCount => _news?.length;
}
