import 'package:dio/dio.dart';

import 'index.dart';

/// Services that retrieves news.
class LecturersService extends BaseService {
  const LecturersService(Dio client) : super(client);

  /// Retrieves a list featuring the latest news.
  Future<Response> getLecturers() async {
    return client.get(
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/lecturers_1.json?alt=media&token=4c32b3a0-88e3-4578-bc4a-f3cef093c8b6',
    );
  }
}
