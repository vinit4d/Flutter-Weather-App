

import 'package:flutter_weather_app/data/dao/weather_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class LocalService{
  static final _instance = LocalService._();
  static LocalService get = _instance;
  bool isInitialized = false;
  late Database _db;

  LocalService._();

  Future<Database> db() async {
    if (!isInitialized) await _init();
    return _db;
  }


  Future _init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "master.db");

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(WeatherDao().createTableQuery);
        });
    isInitialized = true;
  }
  void deleteAllTables() async {

    var connection = _db;
    await connection.rawDelete("delete from ${WeatherDao().tableName}");


    // Logger.info(tag: "deleteAllTablesTAG", message: "All local database deleted successfully");
  }

}