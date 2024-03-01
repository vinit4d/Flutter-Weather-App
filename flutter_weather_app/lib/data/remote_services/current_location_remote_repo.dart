import 'package:flutter_weather_app/domain/entity/current_weather_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../dao/weather_dao.dart';
import '../dto/current_weather_dto.dart';
import '../keys/remote_keys.dart';
import '../remote_repository/current_weather_remote_service.dart';

class CurrentLocationRemoteRepo extends IWeatherRepo {
  CurrentWeatherRemoteServiceIMP services = CurrentWeatherRemoteServiceIMP();

  @override
  Future<List<CurrentWeatherEntity>> getCurrentWeather(
      String lat, String long) async {
    List<CurrentWeatherEntity> list = [];
    try {
      Map<String, dynamic> mapData = {
        "lat": lat,
        "lon": long,
        "appid": RemoteKeys.weatherKey
      };

      CurrentWeatherDto json = await services.getCurrentWeather(mapData);

      list.clear();
      for (var i in json.dataList!) {
        list.add(CurrentWeatherEntity(
            description: i.weather![0].description,
            dtTxt: i.dtTxt,
            humidity: i.main!.humidity,
            visibility: i.visibility,
            icon: i.weather![0].icon,
            main: i.weather![0].main,
            temp: i.main!.temp,
            wind: i.wind!.speed));
      }

      // delete data from local db ---------------------------->

      await WeatherDao().deleteDB();
      // store data in local db ---------------------------->

      for (var j in list) {
        await WeatherDao().insertDB(j.toJson());
      }

      return list;
    } catch (e) {
      return list;
    }
  }
}
