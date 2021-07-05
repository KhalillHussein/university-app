import 'dart:async';

import 'package:dio/dio.dart';

import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

///Repository that update timetable file
class TimetableUploadRepository extends BaseRepository<TimetableUploadService> {
  TimetableUploadRepository(TimetableUploadService service)
      : super(service, autoLoad: false);

  Map formData;

  @override
  Future<void> loadData() async {
    startLoading();
    try {
      await service.uploadTimetable(formData);
      finishLoading();
    } on DioError catch (dioError) {
      try {
        final dynamic error = dioError.response.data['errors']['msg'];
        receivedError(error.toString());
      } catch (e) {
        receivedError(ApiException.fromDioError(dioError).message);
      }
    } catch (error) {
      receivedError(error.toString());
    }
  }
}
