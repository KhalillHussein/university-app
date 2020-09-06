import 'package:flutter/foundation.dart';

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
}
