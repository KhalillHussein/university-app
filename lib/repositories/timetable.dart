import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TimetableRepository(TimetableService service) : super(service) {
    init();
  }

  bool get isUserSetCategory => userCategory != null;

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

  int get itemCount => list?.length;

  Future<void> setUserCategory(String category) async {
    userCategory = category;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('category', userCategory);
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userCategory = prefs.getString('category');
    notifyListeners();
  }

  List<Timetable> getBy(String keyword) {
    return [...list]
        .where((element) =>
            element.group == keyword ||
            element.aud == keyword ||
            element.name == keyword)
        .toList()
          ..sort((a, b) {
            return a.lesson.compareTo(b.lesson);
          });
  }

  Categories getCategory(String category) {
    if (groups.contains(category)) {
      return Categories.group;
    }
    if (lecturers.contains(category)) {
      return Categories.lecturer;
    }
    if (aud.contains(category)) {
      return Categories.auditory;
    }
    return Categories.group;
  }

  List<String> get groups {
    return {for (final item in list) item.group}.toList();
  }

  List<String> get lecturers {
    return {for (final item in list) item.name}.toList()..sort();
  }

  List<String> get aud {
    return {for (final item in list) item.aud}.toList()..sort();
  }
}
