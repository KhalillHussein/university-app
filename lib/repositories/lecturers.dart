import 'package:dio/dio.dart';

import '../models/lecturer.dart';
import '../services/lecturers.dart';
import '../util/index.dart';
import 'index.dart';

/// Repository that holds lecturers data.
class LecturersRepository extends BaseRepository<LecturersService> {
  LecturersRepository(LecturersService service) : super(service);

  List<Lecturer> _lecturers;

  @override
  Future<void> loadData() async {
    try {
      final lecturersResponse = await service.getLecturers();
      _lecturers = [
        for (final item in lecturersResponse.data) Lecturer.fromJson(item)
      ];
      finishLoading();
    } on DioError catch (dioError) {
      receivedError(ApiException.fromDioError(dioError).message);
    } catch (_) {
      receivedError('Internal error');
    }
  }

  List<Lecturer> getByKafedra(String kafedra) {
    return [..._lecturers]
        ?.where((element) => element.kafedra == kafedra)
        ?.toList();
  }

  Lecturer getByLecturer(String name) {
    return _lecturers.singleWhere((element) => element.fullName == name);
  }

  int get itemCount => _lecturers?.length;
}
