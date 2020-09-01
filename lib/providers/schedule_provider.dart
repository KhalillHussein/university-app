import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/schedule.dart';
import '../helpers/db_helper.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _items = [];

  List<Schedule> get items {
    return [..._items];
  }

  Future<void> fetchAndSetResult() async {
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
    } catch (error) {
      print(error);
      if (loadedSchedule.isEmpty) {
        throw error;
      } else {
        await fetchFromDB();
      }
    }
  }

  Future<void> fetchFromDB() async {
    final loadedSchedule = await DBHelper.db.getData('schedule');
    _items = loadedSchedule
        .map(
          (item) => Schedule(
            id: item['id'],
            date: DateTime.parse(item['date']),
            couple: item['couple'],
            lesson: item['lesson'],
            type: item['type'],
            teacher: item['teacher'],
            room: item['room'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
