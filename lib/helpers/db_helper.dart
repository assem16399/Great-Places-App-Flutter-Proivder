import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    //await sql.deleteDatabase(path.join(dbPath, 'places.db'));

    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,location_lat REAL,location_lng REAL,location_address TEXT )');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    final fetchedData = await db.query(table);
    return fetchedData;
  }

  static Future<void> deleteRecord(String id) async {
    final db = await DBHelper.database();
    await db.rawDelete('DELETE FROM user_places WHERE id = ?', [id]);
  }
}
