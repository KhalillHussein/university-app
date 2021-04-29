import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Timetable {
  final String id;
  final String group;
  final String lesson;
  final String aud;
  final String name;
  final String subject;
  final String subjectType;
  final DateTime date;
  final String cafedra;
  final int timestamp;

  const Timetable({
    @required this.id,
    @required this.group,
    @required this.lesson,
    @required this.aud,
    @required this.name,
    @required this.subject,
    @required this.subjectType,
    @required this.date,
    @required this.cafedra,
    this.timestamp,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['_id'],
      group: json['GROUP'] ?? json['studGROUP'],
      lesson: json['LES'],
      aud: json['AUD'],
      name: json['NAME'],
      subject: json['SUBJECT'],
      subjectType: json['SUBJ_TYPE'],
      date: DateFormat('dd-MM-yyyy').parse(json['DATE']),
      cafedra: json['CAFEDRA'],
      timestamp: json['timestamp'],
    );
  }
}
