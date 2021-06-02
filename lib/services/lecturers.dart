import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves lecturers.
class LecturersService extends BaseService {
  const LecturersService(Dio client) : super(client);

  /// Retrieves a list of lecturers.
  Future<Response> getLecturers() async {
    return client.get(Url.lecturers);
  }
}
