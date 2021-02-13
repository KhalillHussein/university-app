// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// import '../helpers/db_helper.dart';
// import '../services/timetable_db.dart';
//
// import '../models/timetable_db.dart';
// import 'base_db.dart';
//
// class ScheduleRepository extends BaseRepository<ScheduleService> {
//   List<Schedule> _schedule;
//
//   ScheduleRepository(ScheduleService service) : super(service);
//
//   @override
//   bool hasReachedMax() {
//     return false;
//   }
//
//   @override
//   void nextPage() {}
//
//   @override
//   Future<void> loadData({int pageIndex, int limit}) async {
//     try {
//      // final loadedSchedule = await DBHelper.db.getData('schedule');
//       final scheduleResponse = await service.getSchedule(pageIndex: pageIndex, limit: limit);
//
//       final responseResult = scheduleResponse.data['result']['docs'];
//       // DBHelper.db.clearTable('schedule');
//       // extractedData.forEach((scheduleItem) {
//       //   DBHelper.db.insert('schedule', {
//       //     'id': scheduleItem['id'],
//       //     'date': scheduleItem['date'],
//       //     'couple': scheduleItem['couple'],
//       //     'lesson': scheduleItem['lesson'],
//       //     'type': scheduleItem['type'],
//       //     'teacher': scheduleItem['teacher'],
//       //     'room': scheduleItem['room'],
//       //   });
//       // });
//       await fetchFromDB();
//     } catch (e) {
//       if (loadedSchedule.isEmpty) {
//         receivedError(e);
//       } else {
//         await fetchFromDB();
//       }
//     }
//   }
//
//   Future<void> fetchFromDB() async {
//     final loadedSchedule = await DBHelper.db.getData('schedule');
//     _schedule = [for (final item in loadedSchedule) Schedule.fromJson(item)];
//     finishLoading();
//   }
//
//   List<Schedule> get schedule => _schedule;
//
//   int get itemCount => _schedule?.length;
// }

import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/repositories/index.dart';
import '../helpers/services/index.dart';
import '../models/index.dart';
import '../services/index.dart';

import 'index.dart';

class TimetableRepository extends BaseRepository<TimetableService> {
  List<Timetable> _timetable;
  final TimetableDbRepository _dbRepository =
      TimetableDbRepository(TimeTableDbService());

  TimetableRepository(TimetableService service) : super(service);

  @override
  Future<void> loadData({int pageIndex, int limit}) async {
    try {
      final timetableResponse = await service.getTimetable();
      _timetable = [
        for (final item in timetableResponse.data['result'])
          Timetable.fromJson(item)
      ];
      for (final item in _timetable) {
        _dbRepository.insert(item);
      }
      finishLoading();
    } on DioError catch (_) {
      fetchFromDB();
      //receivedError('[NETWORK ERROR]');
    } on DatabaseException catch (_) {
      //receivedError('[DATABASE ERROR]');
    } catch (_) {
      fetchFromDB();
      // receivedError('[PARSER ERROR]');
    }
  }

  Future<void> fetchFromDB() async {
    try {
      final dbResult = await _dbRepository.getRecords();
      _timetable = [for (final item in dbResult) Timetable.fromJson(item)];
      finishLoading();
    } catch (e) {
      receivedError(e);
    }
  }

  List<Timetable> get timetable => _timetable;

  int get itemCount => _timetable?.length;

  List<Timetable> getByGroup(String group) {
    return [..._timetable]
        ?.where((element) => element.group == group)
        ?.toList();
  }
}
