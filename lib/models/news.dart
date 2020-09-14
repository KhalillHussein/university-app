import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../util/url.dart';

class News {
  final String id;
  final List<String> images;
  final String title;
  final String introText;
  final String fullText;
  final int views;
  final DateTime date;

  News({
    @required this.images,
    @required this.id,
    @required this.title,
    @required this.introText,
    @required this.fullText,
    @required this.views,
    @required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'],
      title: json['title'],
      images: [for (final item in json['images']) '${Url.newsImgUrl}$item'],
      introText: json['introText'],
      fullText: json['fullText'],
      views: json['views'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  String get getDate => DateFormat.yMMMd('Ru').format(date);
}
