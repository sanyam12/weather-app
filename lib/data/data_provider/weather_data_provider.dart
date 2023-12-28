import 'package:http/http.dart' as http;

class WeatherDataProvider{
  final http.Client client;

  WeatherDataProvider({required this.client});

  Future<String> getCurrentWeather(double lat, double lon)async{
    try {
      final res = await client.get(
        Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=31ddfaf8cbb4c849e8c58642a5acb0f4"),
      );
      if(res.statusCode!=200){
        throw res.body;
      }
      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }
}