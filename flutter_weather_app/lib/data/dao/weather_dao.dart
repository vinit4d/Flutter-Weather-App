import 'package:flutter_weather_app/data/local_services/dao.dart';

import '../../domain/entity/current_weather_entity.dart';
import '../local_services/local_services.dart';

class WeatherDao extends IDao<CurrentWeatherEntity> {
  LocalService services = LocalService.get;

  final temp = 'temp';
  final humidity = 'humidity';
  final visibility = 'visibility';
  final main = 'main';
  final description = 'description';
  final icon = 'icon';
  final wind = 'wind';
  final dtTxt = 'dt_txt';

  @override
  // TODO: implement tableName
  String get tableName => "weatherApp";

  @override
  // TODO: implement createTableQuery
  String get createTableQuery => "CREATE TABLE $tableName( $temp INT,"
      " $humidity DOUBLE,"
      " $visibility DOUBLE,"
      " $main TEXT,"
      " $description TEXT,"
      " $icon TEXT,"
      " $wind INT,"
      " $dtTxt TEXT)";

  @override
  List<CurrentWeatherEntity> fromList(List<dynamic> query) {
    // TODO: implement fromList
    List<CurrentWeatherEntity> entity = [];
    for(dynamic map in query){
      entity.add(fromMap(map));
    }
    return entity;
  }

  @override
  CurrentWeatherEntity fromMap(Map<String, dynamic> query) {
    return CurrentWeatherEntity.fromJson(query);
  }

  @override
  Future<List<CurrentWeatherEntity>> getAllData(String id) async{
    // TODO: implement getAllData
    final db = await services.db();
    List<Map<String,dynamic>> maps = await db.query(tableName);
    return fromList(maps);
  }

  @override
  Future<int> insertDB(Map<String, dynamic> entity) async{
    // TODO: implement insertDB
    final db = await services.db();
    int id = await db.insert(tableName, entity);

    print("Table $tableName: $id"+ "Inserted id = $id");
    // Logger.debug(tag: "Table $tableName: $id", message: "Inserted id = $id");
    return id;
  }


  @override
  Future<int> deleteDB() async{
    // TODO: implement deleteDB
    try{
      final db = await services.db();
      int isDeleted = await db.delete(tableName);
      // Logger.debug(tag:"Table $tableName Deleted",message: isDeleted);
      return isDeleted;
    }catch(e){
      // Logger.debug(tag:"Table $tableName Error",message: e);
      throw Exception(e);
    }
  }

  @override
  Future<void> checkIdExistence(List<CurrentWeatherEntity> list) {
    // TODO: implement checkIdExistence
    throw UnimplementedError();
  }

  @override
  Future<void> checkIdExistenceForOne(CurrentWeatherEntity entity) {
    // TODO: implement checkIdExistenceForOne
    throw UnimplementedError();
  }




  @override
  Future<int> insertAll(List<CurrentWeatherEntity> list) {
    // TODO: implement insertAll
    throw UnimplementedError();
  }




  @override
  CurrentWeatherEntity toMap(CurrentWeatherEntity object) {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  Future<int> updateDB(CurrentWeatherEntity entity) {
    // TODO: implement updateDB
    throw UnimplementedError();
  }
}
