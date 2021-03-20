import 'package:dio/dio.dart';
import 'package:mtusiapp/helpers/db_helper.dart';

import 'package:mtusiapp/util/exception.dart';
import 'package:sqflite/sqflite.dart';

import '../models/index.dart';
import '../services/index.dart';

import 'index.dart';

/// Repository that holds timetable data.
class TimetableRepository extends BaseRepository<TimetableService> {
  List<Timetable> _timetable;
  Database db;

  TimetableRepository(TimetableService service) : super(service);

  @override
  Future<void> loadData() async {
    try {
      final timetableResponse = await service.getTimetable();
      _timetable = [
        for (final item in timetableResponse.data['result'])
          Timetable.fromJson(item)
      ];
      for (final item in timetableResponse.data['result']) {
        DatabaseHelper.db
            .insert(service.tableName, service.toMap(Timetable.fromJson(item)));
      }
      finishLoading();
    } on DioError catch (dioError) {
      errorMessage = ApiException.fromDioError(dioError).message;
      fetchFromDB();
    } on DatabaseException catch (dbError) {
      receivedError(dbError.toString());
    } catch (error) {
      receivedError(error);
    }
  }

  Future<void> fetchFromDB() async {
    try {
      final dbResult = await service.getRecords();
      if (dbResult.isEmpty) throw errorMessage;
      _timetable = [for (final item in dbResult) Timetable.fromJson(item)];
      timestamp =
          DateTime.fromMillisecondsSinceEpoch(_timetable.last.timestamp);
      databaseFetching();
    } catch (e) {
      receivedError(e.toString());
    }
  }

  List<Timetable> get timetable => _timetable;

  int get itemCount => _timetable?.length;

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
