import 'package:dio/dio.dart';
import 'package:mtusiapp/util/exception.dart';

import '../models/lecturer.dart';
import '../services/lecturers.dart';
import 'index.dart';

/// Repository that holds lecturers data.
class LecturersRepository extends BaseRepository<LecturersService> {
  List<Lecturer> _lecturers;

  LecturersRepository(LecturersService service) : super(service);

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
      receivedError('[PARSER ERROR]');
    }
  }

  List<Lecturer> get lecturers => _lecturers;

  List<Lecturer> getByKafedra(String kafedra) {
    return [..._lecturers]
        ?.where((element) => element.kafedra == kafedra)
        ?.toList();
  }

  int get itemCount => _lecturers?.length;
}
