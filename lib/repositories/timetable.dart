import 'package:dio/dio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sqflite/sqflite.dart';

import '../helpers/db_helper.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../util/index.dart';
import 'index.dart';

enum Categories { group, auditory, lecturer }

/// Repository that holds timetable data.
class TimetableRepository extends BaseRepository<Timetable, TimetableService> {
  Database db;

  String userCategory;

  TimetableRepository(TimetableService service) : super(service);

  bool get isUserSetCategory => userCategory != null;

  void setUserCategory(String category) {
    userCategory = category;
    notifyListeners();
  }

  @override
  Future<void> loadData() async {
    try {
      final timetableResponse = await service.getTimetable();
      list = [
        for (final item in timetableResponse.data['result'])
          Timetable.fromJson(item)
      ];
      list.removeWhere((element) => element.aud.contains('+'));
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
        ?.toList()
          ..sort((a, b) {
            return a.lesson.compareTo(b.lesson);
          });
  }

  List<Map<String, dynamic>> searchCategories() {
    final List<Map<String, dynamic>> lec = [
      for (final item in lecturers)
        {
          'name': item,
          'group': 'Преподаватель',
          'icon': MdiIcons.accountTie,
          'category': Categories.lecturer,
        }
    ];
    final List<Map> gr = {
      for (final item in groups)
        {
          'name': item,
          'group': 'Группа',
          'icon': MdiIcons.accountGroup,
          'category': Categories.group,
        }
    }?.toList();
    final List<Map> au = {
      for (final item in aud)
        {
          'name': item,
          'group': 'Аудитория',
          'icon': MdiIcons.domain,
          'category': Categories.auditory,
        }
    }?.toList();
    return [...lec, ...gr, ...au];
  }

  List<String> get groups {
    return {for (final item in timetable) item.group}?.toList();
  }

  List<String> get lecturers {
    return {for (final item in timetable) item.name}?.toList()..sort();
  }

  List<String> get aud {
    return {for (final item in timetable) item.aud}?.toList()..sort();
  }
}
