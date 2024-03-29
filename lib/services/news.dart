import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves news.
class NewsService extends BaseService {
  const NewsService(Dio client) : super(client);

  /// Retrieves a paginated list featuring the latest news.
  Future<Response> getNews({int limit, int pageIndex}) async {
    return client.get(Url.news, queryParameters: {
      'limit': limit,
      'page': pageIndex,
    });
  }
}
