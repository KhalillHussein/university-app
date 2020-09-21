import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/schedule.dart';
import '../helpers/db_helper.dart';
import 'base.dart';

class ScheduleRepository extends BaseRepository {
  List<Schedule> _schedule = [];

  List<Schedule> get schedule {
    return [..._schedule];
  }

  int get itemCount {
    return _schedule.length;
  }

  @override
  Future<void> loadData() async {
    final loadedSchedule = await DBHelper.db.getData('schedule');
    const url =
        'https://constitutive-agents.000webhostapp.com/schedule-short.json';
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
}
