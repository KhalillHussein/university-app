import 'package:intl/intl.dart';

import '../util/url.dart';

class News {
  final String id;
  final List<String> images;
  final String title;
  final String introText;
  final String fullText;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;

  const News({
    this.images,
    this.id,
    this.title,
    this.introText,
    this.fullText,
    this.views,
    this.createdAt,
    this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'],
      title: json['title'],
      images: [
        for (final item in json['images']) '${Url.baseUrl}/${item['path']}'
      ],
      introText: json['introText'],
      fullText: json['fullText'],
      views: json['views'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get getDate => DateFormat.yMMMd('Ru').format(createdAt);
}
