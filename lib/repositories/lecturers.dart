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
        for (final item in lecturersResponse.data['result'])
          Lecturer.fromJson(item)
      ];
      finishLoading();
    } catch (e) {
      receivedError(e);
    }
  }

  List<Lecturer> get lecturers => _lecturers;

  int get itemCount => _lecturers?.length;
}
