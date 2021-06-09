import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

/// Repository that holds news data.
// class NewsRepository extends BaseRepository<NewsService> {
//   final int limit = 12;
//   List<News> _news;
//   int pageIndex;
//   PagingState pagingState = PagingState<int, News>();
//
//   NewsRepository(NewsService service) : super(service);
//
//   @override
//   Future<void> loadData() async {
//     // Try to load the data using [ApiService]
//     try {
//       // Receives the data and parse it
//       final newsResponse =
//           await service.getNews(pageIndex: pageIndex, limit: limit);
//       _news = [
//         for (final item in newsResponse.data['result']['docs'])
//           News.fromJson(item)
//       ];
//       debugPrint(
//           'page ${newsResponse.data['result']['page']}'); //showing current page number
//       //
//       finishLoading();
//       final bool isLastPage = _news.length < limit;
//       if (isLastPage) {
//         appendPage(_news, null);
//       } else {
//         final nextPageKey = pageIndex + 1;
//         appendPage(_news, nextPageKey);
//       }
//       //
//     } on DioError catch (dioError) {
//       error = ApiException.fromDioError(dioError).message;
//       receivedError(error);
//     } catch (_) {
//       error = 'Internal error';
//       receivedError(error);
//     }
//   }
//
//   @override
//   Future<void> refreshData() {
//     pagingState = PagingState<int, News>(
//       nextPageKey: pageIndex = 1,
//     );
//     return loadData();
//   }
//
//   void retryLastFailedRequest() => loadData();
//
//   /// The current error, if any. Initially `null`.
//   dynamic get error => pagingState.error;
//
//   set error(dynamic newError) {
//     pagingState = PagingState<int, News>(
//       error: newError,
//       itemList: pagingState.itemList,
//       nextPageKey: pageIndex,
//     );
//   }
//
//   void appendPage(List<News> newItems, int nextPageKey) {
//     final List<News> previousItems = pagingState.itemList ?? [];
//     final List<News> itemList = {...previousItems, ..._news}.toList()
//       ..sort((a, b) => b.date.compareTo(a.date));
//     pagingState = PagingState<int, News>(
//       itemList: itemList,
//       nextPageKey: nextPageKey,
//     );
//     notifyListeners();
//   }
//
//   void deleteItem(String id) {
//     pagingState.itemList.removeWhere((element) => element.id == id);
//     pagingState = PagingState<int, News>(
//       itemList: pagingState.itemList,
//       nextPageKey: pageIndex,
//     );
//     notifyListeners();
//   }
//
//   int get itemCount => _news?.length;
// }

class NewsRepository extends BasePaginationRepository<News, NewsService> {
  NewsRepository(NewsService service) : super(service);

  @override
  Future<void> loadData() async {
    // Try to load the data using [ApiService]
    try {
      // Receives the data and parse it
      final newsResponse =
          await service.getNews(pageIndex: pageIndex, limit: limit);
      itemList = [
        for (final item in newsResponse.data['result']['docs'])
          News.fromJson(item)
      ];
      debugPrint(
          'page ${newsResponse.data['result']['page']}'); //showing current page number
      finishLoading();
      nextPage();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  void deleteItem(String id) {
    pagingState.itemList.removeWhere((element) => element.id == id);
    pagingState = PagingState<int, News>(
      itemList: pagingState.itemList,
      nextPageKey: pageIndex,
    );
    notifyListeners();
  }

  int get itemCount => itemList?.length;
}
