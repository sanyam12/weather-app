import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanyam_weather_app/bloc/theme_bloc.dart';
import 'package:sanyam_weather_app/data/data_provider/weather_data_provider.dart';
import 'package:sanyam_weather_app/presentation/screens/weather_screen.dart';
import 'package:http/http.dart' as http;
import 'bloc/weather_bloc.dart';
import 'data/repository/weather_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLight = true;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherDataProvider: WeatherDataProvider(client: http.Client()),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
              context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider(create: (context) => ThemeBloc()),
        ],
        child: BlocListener<ThemeBloc, ThemeState>(
          listener: (context, state) {
            if(state is ThemeToggledState) {
              setState(() {
                _isLight = !_isLight;
              });
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: (_isLight)
                ? ThemeData.light(useMaterial3: true)
                : ThemeData.dark(useMaterial3: true),
            home: const WeatherScreen(),
          ),
        ),
      ),
    );
  }
}
