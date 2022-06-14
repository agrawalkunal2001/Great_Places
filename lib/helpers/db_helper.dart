import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql
        .getDatabasesPath(); // The path to database in device hard-drive. It returns a folder
    return sql.openDatabase(path.join(dbPath, "places.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)");
    }, // This creates a database if no path is found
        version:
            1); // openDatabase requires db folder and db name as well. It opens a database if dbPath is not null and creates a new one otherwise.
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm
            .replace /*This means that if we try to insert a place with same id, it will be over-written */);
  }

  static Future<List<Map<String, dynamic>>> fetch(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
