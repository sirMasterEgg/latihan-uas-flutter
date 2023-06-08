import 'package:latihanuas/models/catatan_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteConfig {
  static Database? _database;
  static const String _TABLE_CATATAN = 'catatan';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      "$path/catatan.db",
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $_TABLE_CATATAN (id TEXT PRIMARY KEY, catatan TEXT, owner TEXT, dateCreated TEXT)'
        );
        print('DB Created');
      },
      version: 2,
    );
    return db;
  }

  Future<void> insertCatatan(CatatanModel catatanModel) async{
    final Database db = await database;
    if (db != null) {
      try {
        await db.insert(_TABLE_CATATAN, catatanModel.toMap());
        print('Data inserted');
      } catch (_) {
        print('Error inserting data');
      }
    } else {
      print('Error: Database is not initialized');
    }

  }

  Future<List<CatatanModel>> getCatatans(String owner) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_TABLE_CATATAN, where: 'owner = ?', whereArgs: [owner]);
    return results.map((res) => CatatanModel.fromMap(res)).toList();
  }

  Future<void> deleteCatatan(CatatanModel catatanModel) async {
    final Database db = await database;
    await db.delete(_TABLE_CATATAN, where: 'id = ?', whereArgs: [catatanModel.id]);
  }

  Future<void> updateCatatan(CatatanModel catatanModel) async {
    final Database db = await database;
    await db.update(_TABLE_CATATAN, catatanModel.toMap(), where: 'id = ?', whereArgs: [catatanModel.id]);
  }
}