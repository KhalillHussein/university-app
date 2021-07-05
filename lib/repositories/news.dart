import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

/// Repository that holds news data.
class NewsRepository extends BasePaginationRepository<News, NewsService> {
  NewsRepository(NewsService service) : super(service, autoLoad: false);

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
      ]..sort((a, b) => b.date.compareTo(a.date));
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
