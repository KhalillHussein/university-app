import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/repositories/index.dart';
import '../models/index.dart';
import '../services/index.dart';

import 'index.dart';

/// Repository that holds timetable data.
class TimetableRepository extends BaseRepository<TimetableService> {
  List<Timetable> _timetable = [];

  BaseDbRepository dbRepository;

  TimetableRepository(TimetableService service) : super(service);

  @override
  Future<void> loadData({int pageIndex, int limit}) async {
    try {
      final timetableResponse = await service.getTimetable();
      for (final item in timetableResponse.data['result']) {
        _timetable.add(Timetable.fromJson(item));
        dbRepository.insert(Timetable.fromJson(item));
      }
      finishLoading();
    } on DioError catch (_) {
      fetchFromDB();
      receivedError('[NETWORK ERROR]');
    } on DatabaseException catch (_) {
      // fetchFromDB('[DATABASE ERROR]');
    } catch (_) {
      //  fetchFromDB('[PARSER ERROR]');
    }
  }

  Future<void> fetchFromDB() async {
    startLoading();
    try {
      final dbResult = await dbRepository.getRecords();
      if (dbResult.isEmpty) throw 'TABLE IS EMPTY';
      _timetable = [for (final item in dbResult) Timetable.fromJson(item)];
      finishLoading();
    } catch (e) {
      receivedError(e.toString());
    }
  }

  List<Timetable> get timetable => _timetable;

  int get itemCount => _timetable?.length;

  @override
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(_timetable.first.timestamp);

  List<Timetable> getByGroup(String group) {
    return [..._timetable]
        ?.where((element) => element.group == group)
        ?.toList();
  }

  List<String> get groups {
    return {for (final item in timetable) item.group}?.toList();
  }

  List<String> get course {
    return [
      for (final item in groups)
        item.substring(item.length - 2, item.length - 1)
    ]?.toList();
  }
}
