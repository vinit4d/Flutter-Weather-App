import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/data/dao/weather_dao.dart';
import 'package:flutter_weather_app/domain/utlis/network_helper/network_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../../data/remote_services/current_location_remote_repo.dart';
import '../../../../domain/entity/current_weather_entity.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());
  CurrentLocationRemoteRepo service = CurrentLocationRemoteRepo();
  bool observeText = true;
  final email = TextEditingController();
  final password = TextEditingController();
  Position? currentPosition;
  String city = '';
  String country = '';

  String day = 'Today';
  List<CurrentWeatherEntity> list = [];

  void toggle() {
    observeText = !observeText;
    emit(HomeRefreshState());
  }

  // fetch weather report from lat long --------------------------->>>>>>

  void getCurrentWeather(Position position) async {
    try {
      list.clear();

      bool network = await NetworkHelper.isConnected();

      if (network) {
        list = await service.getCurrentWeather(
            position.latitude.toString(), position.longitude.toString());
      } else {
        list = await WeatherDao().getAllData("");
      }
      emit(HomeSuccessState());
    } catch (e) {
      print(e.toString());
    }
  }

  // convert temp to Celsius --------------------------->>>>>>

  String convertCelsius(temp) {
    num temperature = (temp - 273.15).round();
    return temperature.toString();
  }

  // get users current location --------------------------->>>>>>

  Future<void> getCurrentLocation() async {
    emit(HomeLoadingState());
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition = position;

      await getAddressFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);
      getCurrentWeather(currentPosition!);
      // });
    } catch (e) {
      print('Error: $e');
    }
  }

  // convert date time to  date only --------------------------->>>>>>

  String dateConvert(dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    String formattedDate = DateFormat('EEEE, d MMM').format(dateTime);

    return formattedDate;
  }

  // convert date time to today date only --------------------------->>>>>>
  String todayDate() {
    String formattedDate = DateFormat('EEEE, d MMM').format(DateTime.now());

    print(formattedDate);
    return formattedDate;
  }

  // convert date time to time only --------------------------->>>>>>

  String timeConvert(timeString) {
    DateTime dateTime = DateTime.parse(timeString);

    String formattedTime = DateFormat('h a').format(dateTime);
    return formattedTime;
  }

  // fetch user address from coordinates --------------------------->>>>>>

  Future<void> getAddressFromCoordinates(lat, long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];

        city = placemark.locality!;

        country = placemark.country!;

        emit(HomeRefreshState());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // fetch user address from coordinates --------------------------->>>>>>

  String weatherImg(v) {
    if ('Clouds' == v) {
      return 'clouds';
    } else if ('Clouds' == v) {
      return 'clouds';
    } else if ('Rainy' == v) {
      return 'thunderstorm';
    } else if ('thunderstorm' == v) {
      return 'thunderstorm';
    } else {
      return 'sunny';
    }
  }

  //  toggle days ------------------------->>

  void toggleDays(String selectedDay) {
    day = selectedDay;
    print(day);
    emit(HomeSuccessState());
  }

  //  show weather report according  day --------------->>>

  List searchAccordingName(String data) {
    if (data == "Today") {
      return list
          .where((data) => dateConvert(data.dtTxt) == todayDate())
          .toList();
    } else if (data == 'Tomorrow') {
      DateTime now = DateTime.now();
      DateTime tomorrow = now.add(const Duration(days: 1));

      String formattedDate = DateFormat('EEEE, d MMM').format(tomorrow);

      List listData = list
          .where((data) => dateConvert(data.dtTxt) == formattedDate)
          .toList();

      print(jsonEncode(listData));

      return listData;
    } else {
      return getWeekWeatherReport();
    }
  }

//   fetch 7 days weather report ---------------------->>

  List getWeekWeatherReport() {
    DateTime currentDate = DateTime.now();

    Map<String, dynamic> firstIndexedDataByDate = {};

    for (var forecast in list) {
      String date = forecast.dtTxt!.substring(0, 10);
      if (DateTime.parse(forecast.dtTxt!).isAfter(currentDate) &&
          !firstIndexedDataByDate.containsKey(date)) {
        firstIndexedDataByDate[date] = forecast;
      }
    }

    List<dynamic> firstIndexDataList = firstIndexedDataByDate.values.toList();

    return firstIndexDataList;
  }


//   get day from date ------------->>>>>>>>>>


  String getDayOfWeek(String selectedDate) {
    DateTime date = DateTime.parse(selectedDate);


    switch (date.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thurs";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }
}
