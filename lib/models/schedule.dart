import 'package:flutter/foundation.dart';

class Schedule {
  final int id;
  final DateTime date;
  final int couple;
  final String lesson;
  final String type;
  final String teacher;
  final String room;

  Schedule({
    @required this.id,
    @required this.date,
    @required this.couple,
    @required this.lesson,
    @required this.type,
    @required this.teacher,
    @required this.room,
  });
}
