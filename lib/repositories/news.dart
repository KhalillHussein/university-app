import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/news.dart';
import '../util/url.dart';

import 'base.dart';

/// Repository that holds news data.
class NewsRepository extends BaseRepository {
  List<News> _news;

  @override
  Future<void> loadData() async {
    try {
      final response = await http.get(Url.allNewsUrl);
      final responseData = json.decode(response.body);
      if (responseData['errors'] != null) {
        receivedError();
      }
      final responseResult = responseData['result'];
      _news = [for (final item in responseResult) News.fromJson(item)]
        ..sort((a, b) => b.date.compareTo(a.date));
      finishLoading();
    } catch (_) {
      receivedError();
    }
  }

  List<News> get news => _news;

  int get itemCount => _news?.length;
}
