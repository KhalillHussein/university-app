import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mtusiapp/helpers/db_helper.dart';
import 'package:mtusiapp/models/index.dart';

import '../util/index.dart';
import 'index.dart';

/// Services that retrieves timetable.
class TimetableService extends BaseService {
  TimetableService(Dio client) : super(client) {
    DatabaseHelper.db.query = createTableQuery;
  }

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

  /// Retrieves a list featuring the latest timetable.
  Future<Response> getTimetable() async {
    return client.get(Url.allScheduleUrl);
  }

  Future<List<Object>> getRecords() {
    return DatabaseHelper.db.getRecords(tableName);
  }

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
