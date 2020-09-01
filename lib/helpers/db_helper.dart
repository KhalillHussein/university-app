import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'university.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  Future<void> _createDb(Database db) async {
    await db.execute(
        'CREATE TABLE schedule(id INTEGER PRIMARY KEY, date TEXT, couple INTEGER,lesson TEXT,type TEXT,teacher TEXT,room TEXT)');
//    await db.execute(
//        'CREATE TABLE news(id TEXT PRIMARY KEY,title TEXT,text TEXT,img TEXT, date TEXT)');
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.execute('DELETE FROM $table');
  }
}
