import 'package:dio/dio.dart';

import 'index.dart';

/// Services that retrieves news.
class LecturersService extends BaseService {
  const LecturersService(Dio client) : super(client);

  /// Retrieves a list featuring the latest news.
  Future<Response> getLecturers() async {
    return client.get(
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/lecturers_full.json?alt=media&token=b6b92f37-600e-4f8e-814e-9823c46939a6',
    );
  }
}
