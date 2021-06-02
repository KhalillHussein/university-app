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
class TimetableRepository extends BaseRepository<TimetableService> {
  Database db;

  String userCategory;

  List<Timetable> _timetable = [];

  TimetableRepository(TimetableService service) : super(service) {
    init();
  }

  bool get isUserSetCategory => userCategory != null;

  @override
  Future<void> loadData() async {
    try {
      //load data from api
      final timetableResponse = await service.getTimetable();
      //fill the list of data with removing unnecessary data
      _timetable = [
        for (final item in timetableResponse.data['result'])
          Timetable.fromJson(item)
      ]..removeWhere((element) => element.aud.contains('+'));
      //prepare table by clean old data
      DatabaseHelper.db.clearTable(service.tableName);
      //fill table by new data
      for (final item in _timetable) {
        DatabaseHelper.db.insert(service.tableName, service.toMap(item));
      }
      //signals that data loading is finished
      finishLoading();
    } on DioError catch (dioError) {
      errorMessage = ApiException.fromDioError(dioError).message;
      loadDataFromDb();
    } catch (error) {
      errorMessage = error.toString();
      loadDataFromDb();
      // receivedError(error);
    }
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userCategory = prefs.getString('category');
    notifyListeners();
  }

  Future<void> loadDataFromDb() async {
    try {
      final dbResult = await service.getDbRecords();
      if (dbResult.isEmpty) throw errorMessage;
      _timetable = [for (final item in dbResult) Timetable.fromJson(item)];
      timestamp =
          DateTime.fromMillisecondsSinceEpoch(_timetable.last.timestamp);
      databaseFetching();
    } catch (e) {
      receivedError(e.toString());
    }
  }

  int get itemCount => _timetable?.length;

  Future<void> setUserCategory(String category) async {
    userCategory = category;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('category', userCategory);
  }

  List<Timetable> getBy(String keyword) {
    return [..._timetable]
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

  List<Timetable> get timetable => _timetable;

  List<String> get groups {
    return {for (final item in _timetable) item.group}.toList();
  }

  List<String> get lecturers {
    return {for (final item in _timetable) item.name}.toList()..sort();
  }

  List<String> get aud {
    return {for (final item in _timetable) item.aud}.toList()..sort();
  }
}
