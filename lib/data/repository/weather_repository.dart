import 'dart:convert';

import '../data_provider/weather_data_provider.dart';
import '../model/weather_model.dart';
import 'package:geolocator/geolocator.dart';


class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository({required this.weatherDataProvider});

  Future<WeatherModel> getCurrentWeather() async {
    try {
      var position = await _determinePosition();
      final weatherData = await weatherDataProvider.getCurrentWeather(
        position.latitude,
        position.longitude,
      );
      return WeatherModel.fromJson(weatherData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
