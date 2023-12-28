import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:sanyam_weather_app/bloc/theme_bloc.dart';
import 'package:sanyam_weather_app/bloc/weather_bloc.dart';
import 'package:sanyam_weather_app/presentation/widgets/additional_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String animation = "idle";
  Artboard? _artBoard;
  SMITrigger? trigger;
  StateMachineController? controller;

  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(WeatherFetched());
    rootBundle.load("assets/switch.riv").then((value) {
      var artBoard = RiveFile.import(value).mainArtboard;
      controller =
          StateMachineController.fromArtboard(artBoard, "State Machine 1");
      if (controller != null) {
        artBoard.addController(controller!);
        controller!.inputs.forEach((element) {
        });
        trigger = controller!.inputs.first as SMITrigger;
      }
      setState(() => _artBoard = artBoard);
    });
  }

  Future<Image> _findIcon(String icon) async {
    String link = "https://openweathermap.org/img/wn/$icon@2x.png";
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final Completer<Image> completer = Completer();
      completer.complete(Image.memory(bytes));
      return completer.future;
    } else {
      throw Exception("error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              context.read<WeatherBloc>().add(WeatherFetched());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is! WeatherSuccess) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          state.weatherModel.cityName,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          child: Column(
                            children: [
                              Text(
                                "${state.weatherModel.currentTemp} K",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: FutureBuilder(
                                  future: _findIcon(state.weatherModel.icon),
                                  builder: (context, AsyncSnapshot<Image> image) {
                                    if (image.hasData) {
                                      return image.data!;
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                              Text(
                                state.weatherModel.currentSky,
                                style: const TextStyle(fontSize: 32),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10,
                        ),
                        child: Text(
                          "Additional Information",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AdditionalCard(
                            title: "Humidity",
                            amount: state.weatherModel.currentHumidity.toDouble(),
                            icon: Icons.water_drop,
                          ),
                          AdditionalCard(
                            title: "Wind Speed",
                            amount: state.weatherModel.currentWindSpeed,
                            icon: Icons.air,
                          ),
                          AdditionalCard(
                            title: "Pressure",
                            amount: state.weatherModel.currentPressure.toDouble(),
                            icon: Icons.beach_access,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_artBoard != null)
                Container(
                  width: width,
                  height: 0.76875*(width),
                  child: GestureDetector(
                    onTap: () {
                      context.read<ThemeBloc>().add(ThemeToggled());
                      trigger?.fire();
                    },
                    child: Rive(
                      artboard: _artBoard!,
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
