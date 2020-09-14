import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../util/url.dart';
import '../models/news.dart';

class NewsProvider with ChangeNotifier {
  List<News> _news = [];

  List<News> get news {
    return [..._news];
  }

  int get itemCount {
    return _news.length;
  }

  Future<void> fetchAndSetResult() async {
    try {
      final response = await http.get(Url.allNewsUrl);
      final responseData = json.decode(response.body);
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors']['msg']);
      }
      final responseResult = responseData['result'];
      _news = [for (final item in responseResult) News.fromJson(item)];
      _news.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
