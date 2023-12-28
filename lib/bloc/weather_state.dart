part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

final class WeatherSuccess extends WeatherState{
  final WeatherModel weatherModel;
  WeatherSuccess(this.weatherModel);
}

final class WeatherFailure extends WeatherState{
  final String error;
  WeatherFailure(this.error);
}

final class WeatherLoading extends WeatherState{}
