/// temp : 296.44
/// humidity : 28
/// visibility : 10000
/// main : "Clouds"
/// description : "scattered clouds"
/// icon : "03d"
/// wind : 0.41
/// dt_txt : "2024-02-27 15:00:00"

class CurrentWeatherEntity {
  CurrentWeatherEntity({
      num? temp, 
      num? humidity, 
      num? visibility, 
      String? main, 
      String? description, 
      String? icon, 
      num? wind, 
      String? dtTxt,}){
    _temp = temp;
    _humidity = humidity;
    _visibility = visibility;
    _main = main;
    _description = description;
    _icon = icon;
    _wind = wind;
    _dtTxt = dtTxt;
}

  CurrentWeatherEntity.fromJson(dynamic json) {
    _temp = json['temp'];
    _humidity = json['humidity'];
    _visibility = json['visibility'];
    _main = json['main'];
    _description = json['description'];
    _icon = json['icon'];
    _wind = json['wind'];
    _dtTxt = json['dt_txt'];
  }
  num? _temp;
  num? _humidity;
  num? _visibility;
  String? _main;
  String? _description;
  String? _icon;
  num? _wind;
  String? _dtTxt;
CurrentWeatherEntity copyWith({  num? temp,
  num? humidity,
  num? visibility,
  String? main,
  String? description,
  String? icon,
  num? wind,
  String? dtTxt,
}) => CurrentWeatherEntity(  temp: temp ?? _temp,
  humidity: humidity ?? _humidity,
  visibility: visibility ?? _visibility,
  main: main ?? _main,
  description: description ?? _description,
  icon: icon ?? _icon,
  wind: wind ?? _wind,
  dtTxt: dtTxt ?? _dtTxt,
);
  num? get temp => _temp;
  num? get humidity => _humidity;
  num? get visibility => _visibility;
  String? get main => _main;
  String? get description => _description;
  String? get icon => _icon;
  num? get wind => _wind;
  String? get dtTxt => _dtTxt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temp'] = _temp;
    map['humidity'] = _humidity;
    map['visibility'] = _visibility;
    map['main'] = _main;
    map['description'] = _description;
    map['icon'] = _icon;
    map['wind'] = _wind;
    map['dt_txt'] = _dtTxt;
    return map;
  }

}