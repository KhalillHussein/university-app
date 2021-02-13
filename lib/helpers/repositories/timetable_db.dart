import 'package:sqflite/sqflite.dart';

import '../../models/timetable.dart';
import '../providers/db_provider.dart';
import '../services/index.dart';
import 'index.dart';

///Repository that performs operations with the [timetable] table.
class TimetableDbRepository
    extends BaseDbRepository<Timetable, TimeTableDbService> {
  DatabaseProvider _databaseProvider;
  Database _db;

  TimetableDbRepository(TimeTableDbService service) : super(service);

  @override
  Future<void> init() async {
    _databaseProvider = DatabaseProvider(service.createTableQuery);
    _db = await _databaseProvider.getDatabase();
  }

  @override
  Future<void> insert(Timetable timetable) async {
    await _db.insert(
      service.tableName,
      service.toMap(timetable),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete(Timetable timetable) async {
    await _db.delete(service.tableName,
        where: '${service.columnId} = ?', whereArgs: [timetable.id]);
  }

  @override
  Future<void> update(Timetable timetable) async {
    await _db.update(service.tableName, service.toMap(timetable),
        where: '${service.columnId} = ?', whereArgs: [timetable.id]);
  }

  @override
  Future<List<Map>> getRecords() async {
    _db = await _databaseProvider.getDatabase();
    final List<Map> maps = await _db.query(service.tableName);
    return maps;
  }
}
