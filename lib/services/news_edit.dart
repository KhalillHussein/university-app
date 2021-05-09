import 'package:dio/dio.dart';
import 'package:mtusiapp/models/index.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that send news to [ApiService].
class NewsEditService extends BaseService {
  const NewsEditService(Dio client) : super(client);

  /// Post news.
  Future<Response> postNews(News news, String token) async {
    return client.post(Url.newsUrl,
        data: FormData.fromMap({
          'title': news.title,
          'introText': news.introText,
          'date': news.createdAt.millisecondsSinceEpoch,
          'fullText': news.fullText,
          'image': [
            for (final imagePath in news.images)
              MultipartFile.fromFileSync(
                imagePath,
                filename: imagePath.split('/').last,
              ),
          ]
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));
  }

  /// Delete news by id.
  Future<Response> deleteNews(String token, String id) async {
    return client.delete('${Url.newsUrl}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));
  }
}
