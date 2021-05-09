import 'package:dio/dio.dart';

import '../models/lecturer.dart';
import '../services/lecturers.dart';
import '../util/index.dart';
import 'index.dart';

/// Repository that holds lecturers data.
class LecturersRepository extends BaseRepository<Lecturer, LecturersService> {
  LecturersRepository(LecturersService service) : super(service);

  @override
  Future<void> loadData() async {
    try {
      final lecturersResponse = await service.getLecturers();
      list = [
        for (final item in lecturersResponse.data) Lecturer.fromJson(item)
      ];
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  // List<Lecturer> get lecturers => list;

  List<Lecturer> getByKafedra(String kafedra) {
    return [...list]?.where((element) => element.kafedra == kafedra)?.toList();
  }

  Lecturer getByLecturer(String name) {
    return list.singleWhere((element) => element.fullName == name);
  }

  int get itemCount => list?.length;
}
