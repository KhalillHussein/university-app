import 'package:intl/intl.dart';

import '../../models/timetable.dart';

import 'index.dart';

///Service that working with the timetable table
class TimeTableDbService extends DbBaseService<Timetable> {
  final String tableName = 'timetable';
  final String columnId = '_id';
  final String timestamp = 'timestamp';
  final String _group = 'studGROUP';
  final String _lesson = 'LES';
  final String _aud = 'AUD';
  final String _name = 'NAME';
  final String _subject = 'SUBJECT';
  final String _subjectType = 'SUBJ_TYPE';
  final String _date = 'DATE';
  final String _cafedra = 'CAFEDRA';

  @override
  String get createTableQuery => """
      CREATE TABLE $tableName
      (
      $columnId TEXT PRIMARY KEY,
      $_group TEXT,
      $_lesson TEXT,
      $_aud TEXT,
      $_name TEXT,
      $_subject TEXT,
      $_subjectType TEXT,
      $_date TEXT,
      $_cafedra TEXT,
      $timestamp INTEGER
      )
      """;

  @override
  Map<String, dynamic> toMap(Timetable object) {
    return <String, dynamic>{
      columnId: object.id,
      _group: object.group,
      _lesson: object.lesson,
      _aud: object.aud,
      _name: object.name,
      _subject: object.subject,
      _subjectType: object.subjectType,
      _date: DateFormat('dd-MM-yyyy').format(object.date).toString(),
      _cafedra: object.cafedra,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    };
  }
}
