import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///Class which prepare initial steps to work with the database
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  Database _db;
  String query;

  Future<Database> get databaseInstance async {
    if (_db != null) return _db;
    return _db = await _getDatabaseInstance();
  }

  Future<Database> _getDatabaseInstance() async {
    final dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'university.db');
    return openDatabase(
      path,
      onCreate: (Database db, int version) async {
        await db.execute(query);
      },
      version: 1,
    );
  }

  ///  method, used for insert operations with the table
  Future<void> insert(String table, Map records) async {
    final db = await databaseInstance;
    await db.insert(
      table,
      records,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///  method, used for clear all data in the table
  Future<void> clearTable(String table) async {
    final db = await databaseInstance;
    await db.delete(table);
  }

  ///  method, used for delete specific data in the table
  Future<void> delete({String table, String columnId, int id}) async {
    final db = await databaseInstance;
    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  /// method, used for get data from the table
  Future<List<Object>> getRecords(String table) async {
    final db = await databaseInstance;
    final List<Map> maps = await db.query(table);
    return maps;
  }
}
