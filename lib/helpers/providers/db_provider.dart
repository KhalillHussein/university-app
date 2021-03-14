import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///Provider which prepare initial steps to work with the database
class DatabaseProvider {
  Database _db;
  String query;

  DatabaseProvider(this.query) : assert(query != null);

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
}
