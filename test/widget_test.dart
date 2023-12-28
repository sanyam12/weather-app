// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sanyam_weather_app/data/data_provider/weather_data_provider.dart';

import 'package:sanyam_weather_app/main.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test("getCurrentWeather returns weather data on success", () async {
    const response = '{"key":"value"}';
    final client = MockClient();
    final weatherDataProvider = WeatherDataProvider(client: client);
    const lat = 12.234;
    const lon = 56.789;
    when(client.get(any)).thenAnswer((_) async => http.Response(response, 200));
    final result = await weatherDataProvider.getCurrentWeather(lat, lon);
    expect(result, response);
  });
  // testWidgets('Theme matching or not', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());
  //
  //   final BuildContext context = tester.element(find.byType(MaterialApp));
  //   final Finder weatherTextFinder = find.text("Weather App");
  //   final Text weatherText = tester.firstWidget(weatherTextFinder);
  //
  //   bool testIsInLightTheme() {
  //     if (Theme.of(context).brightness == Brightness.light) {
  //       return true;
  //     }
  //     return false;
  //   }
  //
  //   expect(
  //     Theme.of(tester.element(find.byWidget(weatherText))).brightness,
  //     equals(Brightness.light),
  //     reason: "Since App just launched, Theme should be in Light mode by default"
  //   );
  //
  //   expect(
  //     weatherText.style?.color,
  //     testIsInLightTheme() ? Colors.black : Colors.white,
  //     reason:
  //     "When MaterialApp is in light theme, text is black. When Material App is in dark theme, text is white",
  //   );
  //
  //
  // });
}
