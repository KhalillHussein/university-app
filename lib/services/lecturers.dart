import 'package:dio/dio.dart';

import 'index.dart';

/// Services that retrieves news.
class LecturersService extends BaseService {
  const LecturersService(Dio client) : super(client);

  /// Retrieves a list featuring the latest news.
  Future<Response> getLecturers() async {
    return client.get(
      'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/lecturers_1.json?alt=media&token=6a4ee138-723f-48f4-86bf-3fe894415e04',
    );
  }
}
