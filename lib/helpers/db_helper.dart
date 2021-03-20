// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';
// import 'package:path/path.dart' as path;
//
// class DBHelper {
//   DBHelper._();
//   static final DBHelper db = DBHelper._();
//   Database _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await getDatabaseInstance();
//     return _database;
//   }
//
//   Future<Database> getDatabaseInstance() async {
//     final dbPath = await sql.getDatabasesPath();
//     return sql.openDatabase(path.join(dbPath, 'university.db'),
//         onCreate: (db, version) => _createDb(db), version: 1);
//   }
//
//   Future<void> _createDb(Database db) async {
//     await db.execute(
//         'CREATE TABLE schedule(id INTEGER PRIMARY KEY, date TEXT, couple INTEGER,lesson TEXT,type TEXT,teacher TEXT,room TEXT)');
//   }
//
//   Future<void> insert(String table, Map<String, dynamic> data) async {
//     final db = await database;
//     await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   Future<List<Map<String, dynamic>>> getData(String table) async {
//     final db = await database;
//     return db.query(table);
//   }
//
//   Future<void> clearTable(String table) async {
//     final db = await database;
//     await db.delete(table);
//   }
// }

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// ///Provider which prepare initial steps to work with the database
// class DatabaseHelper {
//   Database _db;
//   String query;
//
//   DatabaseHelper(this.query) : assert(query != null);
//
//   Future<Database> get databaseInstance async {
//     if (_db != null) return _db;
//     return _db = await _getDatabaseInstance();
//   }
//
//   Future<Database> _getDatabaseInstance() async {
//     final dbPath = await getDatabasesPath();
//     final String path = join(dbPath, 'university.db');
//     return openDatabase(
//       path,
//       onCreate: (Database db, int version) async {
//         await db.execute(query);
//       },
//       version: 1,
//     );
//   }
//
//   ///  method, used for initialization of the [sqflite] database
//   Future<void> init() async {
//     _db = await databaseInstance;
//   }
//
//   ///  method, used for insert operations with the table
//   Future<void> insert(String table, Map records) async {
//     await _db.insert(
//       table,
//       records,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   /// method, used for update data in the table
//   Future<void> update({String table, String columnId, int id}) async {
//     await _db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
//
//   ///  method, used for delete data in the table
//   Future<void> delete({String table, String columnId, int id}) async {
//     await _db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
//
//   /// method, used for get data from the table
//   Future<List<Object>> getRecords(String table) async {
//     final List<Map> maps = await _db.query(table);
//     return maps;
//   }
// }

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///Provider which prepare initial steps to work with the database
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

  /// method, used for update data in the table
  Future<void> update({String table, String columnId, int id}) async {
    final db = await databaseInstance;
    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  ///  method, used for delete data in the table
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
