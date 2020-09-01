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

//  Future<void> fetchAndSetResultOnline() async {
//    const url =
//        'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/schedule-short.json?alt=media&token=1851a1dc-ecc3-4820-bb8e-4b8569914519';
//    try {
//      final response = await http.get(
//        url,
//      );
//      final List<Schedule> loadedSchedule = [];
//      final extractedData = json.decode(
//        utf8.decode(response.bodyBytes),
//      );
//      extractedData.forEach((scheduleData) {
//        loadedSchedule.add(
//          Schedule(
//            id: scheduleData['id'].toString(),
//            date: DateTime.parse(scheduleData['date']),
//            couple: scheduleData['couple'].toString(),
//            lesson: scheduleData['lesson'],
//            type: scheduleData['type'],
//            teacher: scheduleData['teacher'],
//            room: scheduleData['room'].toString(),
//          ),
//        );
//        loadedSchedule.removeWhere((element) => element.room == '+');
//        loadedSchedule.forEach((element) {
//          DBHelper.insert('schedule', {
//            'id': element.id,
//            'date': element.date.toString(),
//            'couple': element.couple,
//            'lesson': element.lesson,
//            'type': element.type,
//            'teacher': element.teacher,
//            'room': element.room,
//          });
//        });
//        _items = loadedSchedule;
//        notifyListeners();
//      });
//    } catch (error) {
//      final loadedSchedule = await DBHelper.getData('schedule');
//      if (loadedSchedule.isEmpty) {
//        throw error;
//      } else {
//        fetchAndSetResultOffline();
//      }
//    }
//  }

//  Future<void> fetchAndSetResultOffline() async {
//    final loadedSchedule = await DBHelper.db.getData('schedule');
//    _items = loadedSchedule
//        .map(
//          (item) => Schedule(
//            id: item['id'],
//            date: DateTime.parse(item['date']),
//            couple: item['couple'].toString(),
//            lesson: item['lesson'],
//            type: item['type'],
//            teacher: item['teacher'],
//            room: item['room'].toString(),
//          ),
//        )
//        .toList();
//    notifyListeners();
//  }

//  Future<void> fetchAndSetResult() async {
//    const url = 'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/schedule.json?alt=media&token=a21841c6-0d01-4c0c-b2d4-1caa0f6cce11';
//    try {
//      final response = await http.get(url,
//      );
//      final List<Schedule> loadedSchedule = [];
//      final extractedData = json.decode(
//        utf8.decode(response.bodyBytes),
//      );
//      extractedData.forEach((scheduleData) {
//        loadedSchedule.add(
//          Schedule(
//            date: DateTime.parse(scheduleData['date']),
//            couple: scheduleData['couple'].toString(),
//            lesson: scheduleData['lesson'],
//            type: scheduleData['type'],
//            teacher: scheduleData['teacher'],
//            room: scheduleData['room'].toString(),
//          ),
//        );
//        loadedSchedule.removeWhere((element) => element.room == '+');
//        _items = loadedSchedule;
//        notifyListeners();
//      });
//    } catch (error) {
//      throw error;
//    }
//  }

}
