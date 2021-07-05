import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that upload timetable to [ApiService].
class TimetableUploadService extends BaseService {
  const TimetableUploadService(Dio client) : super(client);

  /// Upload timetable.
  Future<Response> uploadTimetable(Map formData) async {
    return client.post(
      Url.uploadTimetable,
      data: FormData.fromMap(formData),
    );
  }
}
