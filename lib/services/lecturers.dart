import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves news.
class LecturersService extends BaseService {
  const LecturersService(Dio client) : super(client);

  /// Retrieves a list featuring the latest news.
  Future<Response> getLecturers() async {
    return client.get(Url.lecturersAllUrl);
  }
}
