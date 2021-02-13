import 'package:intl/intl.dart';

import '../../models/timetable.dart';

import 'index.dart';

///Service that working with the timetable table
class TimeTableDbService extends DbBaseService<Timetable> {
  final String tableName = 'timetable';
  final String columnId = '_id';
  final String group = 'studGROUP';
  final String lesson = 'LES';
  final String aud = 'AUD';
  final String name = 'NAME';
  final String subject = 'SUBJECT';
  final String subjectType = 'SUBJ_TYPE';
  final String date = 'DATE';
  final String cafedra = 'CAFEDRA';

  @override
  String get createTableQuery => """
      CREATE TABLE $tableName
      (
      $columnId TEXT PRIMARY KEY,
      $group TEXT,
      $lesson TEXT,
      $aud TEXT,
      $name TEXT,
      $subject TEXT,
      $subjectType TEXT,
      $date TEXT,
      $cafedra TEXT
      )
      """;

  @override
  Map<String, dynamic> toMap(Timetable object) {
    return <String, dynamic>{
      columnId: object.id,
      group: object.group,
      lesson: object.lesson,
      aud: object.aud,
      name: object.name,
      subject: object.subject,
      subjectType: object.subjectType,
      date: DateFormat('dd-MM-yyyy').format(object.date).toString(),
      cafedra: object.cafedra,
    };
  }
}
