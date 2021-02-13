import 'package:dio/dio.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves timetable.
class TimetableService extends BaseService {
  const TimetableService(Dio client) : super(client);

  /// Retrieves a list featuring the latest timetable.
  Future<Response> getTimetable({int limit, int pageIndex}) async {
    return client.get(Url.allScheduleUrl);
  }
}
