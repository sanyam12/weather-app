import 'dart:convert';

class WeatherModel {
  final String cityName;
  final double currentTemp;
  final String currentSky;
  final int currentPressure;
  final double currentWindSpeed;
  final int currentHumidity;
  final String icon;

  WeatherModel({
    required this.cityName,
    required this.currentTemp,
    required this.currentSky,
    required this.currentPressure,
    required this.currentWindSpeed,
    required this.currentHumidity,
    required this.icon,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map){
    return WeatherModel(
        cityName: map["name"],
        currentTemp: map["main"]["temp"],
        currentSky: map["weather"][0]["main"],
        currentPressure: map["main"]["pressure"],
        currentWindSpeed: map["wind"]["speed"],
        currentHumidity: map["main"]["humidity"],
        icon: map["weather"][0]["icon"],
    );
  }

  factory WeatherModel.fromJson(String source)=>
      WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);
}