import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../data/model/weather_model.dart';
import '../data/repository/weather_repository.dart';
part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(WeatherInitial()) {
    on<WeatherFetched>(_onWeatherFetched);
  }

  void _onWeatherFetched(
    WeatherFetched event,
    Emitter<WeatherState> emit,
  ) async{
    emit(WeatherLoading());
    try {
      final weather = await _weatherRepository.getCurrentWeather();
      emit(WeatherSuccess(weather));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
