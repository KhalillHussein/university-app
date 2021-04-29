import 'package:dio/dio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sqflite/sqflite.dart';

import '../helpers/db_helper.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

/// Repository that holds timetable data.
class TimetableRepository extends BaseRepository<Timetable, TimetableService> {
  Database db;

  TimetableRepository(TimetableService service) : super(service);

  @override
  Future<void> loadData() async {
    try {
      final timetableResponse = await service.getTimetable();
      list = [
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
      list = [for (final item in dbResult) Timetable.fromJson(item)];
      timestamp = DateTime.fromMillisecondsSinceEpoch(list.last.timestamp);
      databaseFetching();
    } catch (e) {
      receivedError(e.toString());
    }
  }

  List<Timetable> get timetable => list;

  int get itemCount => list?.length;

  List<Timetable> getBy(String keyword) {
    return [...list]
        ?.where((element) =>
            element.group == keyword ||
            element.aud == keyword ||
            element.name == keyword)
        ?.toList();
  }

  List<Map<String, dynamic>> searchCategories() {
    final List<Map<String, dynamic>> lec = [
      for (final item in lecturers)
        {'name': item, 'category': 'Преподаватель', 'icon': MdiIcons.accountTie}
    ];
    final List<Map> gr = {
      for (final item in groups)
        {'name': item, 'category': 'Группа', 'icon': MdiIcons.accountGroup}
    }?.toList();
    final List<Map> au = {
      for (final item in aud)
        {'name': item, 'category': 'Аудитория', 'icon': MdiIcons.domain}
    }?.toList();
    return [...lec, ...gr, ...au];
  }

  List<String> get groups {
    return {for (final item in timetable) item.group}?.toList();
  }

  List<String> get lecturers {
    return {for (final item in timetable) item.name}?.toList();
  }

  List<String> get aud {
    return {for (final item in timetable) item.aud}?.toList();
  }
}
