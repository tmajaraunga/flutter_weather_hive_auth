import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';


class WeatherService {
// Replace with your OpenWeatherMap API key
  static const String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';


  Future<WeatherModel> fetchWeatherByCity(String city) async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey');
    final res = await http.get(uri).timeout(Duration(seconds: 10));
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      return WeatherModel(
        city: json['name'],
        tempC: (json['main']['temp'] as num).toDouble(),
        description: (json['weather'] as List).first['description'],
      );
    } else {
      throw Exception('Weather fetch failed: ${res.statusCode}');
    }
  }
}