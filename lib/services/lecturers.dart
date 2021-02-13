import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves news.
class LecturersService extends BaseService {
  const LecturersService(Dio client) : super(client);

  /// Retrieves a list featuring the latest news.
  Future<Response> getLecturers({int limit, int pageIndex}) async {
    return client.get(Url.lecturersAllUrl);
  }
}
