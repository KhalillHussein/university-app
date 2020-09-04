import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../util/url.dart';
import '../models/news.dart';

class NewsProvider with ChangeNotifier {
  List<News> _items = [];

  String authToken;
  String userId;

  NewsProvider(this.authToken, this.userId, this._items);

  List<News> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> fetchAndSetResult() async {
    try {
      final response = await http.get(
        Url.allNewsUrl,
//    headers: {
//        'Content-Type': 'application/json',
//        'Accept': 'application/json',
//        'Authorization': 'Bearer $authToken',
//      }
      );
      final List<News> loadedNews = [];
      final responseData = json.decode(response.body);
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors']['msg']);
      }
      final responseResult = responseData['result'];
      responseResult.forEach((newsItem) {
        loadedNews.add(
          News(
            id: newsItem['_id'],
            title: newsItem['title'],
            images: newsItem['images'],
            introText: newsItem['introText'],
            fullText: newsItem['fullText'],
            views: newsItem['views'],
            date: DateTime.fromMillisecondsSinceEpoch(newsItem['date']),
          ),
        );
        _items = loadedNews.reversed.toList();
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

//  Future<void> fetchAndSetResult() async {
//    final loadedNews = await DBHelper.db.getData('news');
//    const url = 'https://constitutive-agents.000webhostapp.com/news.json';
//    try {
//      final response = await http.get(url);
//      final extractedData = json.decode(utf8.decode(response.bodyBytes));
//      DBHelper.db.clearTable('news');
//      extractedData.forEach((newsData) {
//        DBHelper.db.insert('news', {
//          'id': newsData['id'].toString(),
//          'title': newsData['title'],
//          'text': newsData['text'],
//          'img': newsData['img'].reduce((value, element) => value + element),
//          'date': newsData['date'],
//        });
//      });
//      await fetchFromDB();
//    } catch (error) {
//      if (loadedNews.isEmpty) {
//        throw error;
//      } else {
//        await fetchFromDB();
//      }
//    }
//  }
//
//  Future<void> fetchFromDB() async {
//    final loadedNews = await DBHelper.db.getData('news');
//    _items = loadedNews
//        .map(
//          (item) => News(
//            id: item['id'],
//            title: item['title'],
//            text: item['text'],
//            img: item['img'],
//            date: item['date'],
//          ),
//        )
//        .toList();
//    notifyListeners();
//  }
}
