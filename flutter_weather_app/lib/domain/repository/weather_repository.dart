import '../entity/current_weather_entity.dart';

abstract class IWeatherRepo{

  Future<List<CurrentWeatherEntity>> getCurrentWeather(String lat,String long);

}