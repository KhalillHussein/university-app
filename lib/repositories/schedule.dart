import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/db_helper.dart';
import '../models/schedule.dart';
import 'base.dart';

class ScheduleRepository extends BaseRepository {
  List<Schedule> _schedule;

  @override
  Future<void> loadData() async {
    final loadedSchedule = await DBHelper.db.getData('schedule');
    const url =
        'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/schedule-short.json?alt=media&token=a5b1b916-cda8-4403-9749-ee876d57aa0b';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(utf8.decode(response.bodyBytes));
      DBHelper.db.clearTable('schedule');
      extractedData.removeWhere((item) => item['room'] == '+');
      extractedData.forEach((scheduleItem) {
        DBHelper.db.insert('schedule', {
          'id': scheduleItem['id'],
          'date': scheduleItem['date'],
          'couple': scheduleItem['couple'],
          'lesson': scheduleItem['lesson'],
          'type': scheduleItem['type'],
          'teacher': scheduleItem['teacher'],
          'room': scheduleItem['room'],
        });
      });
      await fetchFromDB();
    } catch (_) {
      if (loadedSchedule.isEmpty) {
        receivedError();
      } else {
        await fetchFromDB();
      }
    }
  }

  Future<void> fetchFromDB() async {
    final loadedSchedule = await DBHelper.db.getData('schedule');
    _schedule = [for (final item in loadedSchedule) Schedule.fromJson(item)];
    finishLoading();
  }

  List<Schedule> get schedule => _schedule;

  int get itemCount => _schedule?.length;
}
