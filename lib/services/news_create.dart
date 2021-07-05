import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that sends news to [ApiService].
class NewsCreateService extends BaseService {
  const NewsCreateService(Dio client) : super(client);

  /// Post news.
  Future<Response> postNews(Map formData, String token) async {
    return client.post(Url.news,
        data: FormData.fromMap(formData),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));
  }

  /// Delete news by id.
  Future<Response> deleteNews(String token, String id) async {
    return client.delete('${Url.news}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));
  }
}
