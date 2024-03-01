import '../../domain/services/weather_services.dart';
import '../dto/current_weather_dto.dart';
import '../exceptions/exception.dart';
import '../keys/network_utils.dart';
import '../keys/remote_keys.dart';

class CurrentWeatherRemoteServiceIMP extends WeatherService {
  var headerNew = {
    'Content-Type': 'application/json',
  };

  @override
  Future getCurrentWeather(Map<String, dynamic> mapData) async {
    try {
      final url =
          Uri.https(RemoteKeys.baseURL, "${RemoteKeys.medium}", mapData);

      var res = await NetworkUtils.get(
        url,
        headers: headerNew,
      );
      // if (res.) {
      return CurrentWeatherDto.fromJson(res);
      // }
      //Logger.error(tag: "callLogin Success", message: "e.toString()");
      throw UnAuthorizedException("2", "message");
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
