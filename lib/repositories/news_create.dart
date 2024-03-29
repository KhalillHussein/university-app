import 'dart:async';

import 'package:dio/dio.dart';

import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

///Repository that manage news creation
class NewsCreateRepository extends BaseRepository<NewsCreateService> {
  NewsCreateRepository(NewsCreateService service)
      : super(service, autoLoad: false);
  String token;

  Map formData;

  @override
  Future<void> loadData() async {
    startLoading();
    try {
      await service.postNews(formData, token);
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

  Future<void> deleteData(String id) async {
    startLoading();
    try {
      await service.deleteNews(token, id);
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (error) {
      receivedError(error.toString());
    }
  }
}
