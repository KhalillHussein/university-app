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
    this.id,
    this.group,
    this.lesson,
    this.aud,
    this.name,
    this.subject,
    this.subjectType,
    this.date,
    this.cafedra,
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
      date: json['DATE'] == ""
          ? DateTime.now()
          : DateFormat('dd-MM-yyyy').parse(json['DATE']),
      cafedra: json['CAFEDRA'],
      timestamp: json['timestamp'],
    );
  }
}
