import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class ClimoraWeatherApi {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  ClimoraWeatherApi({required this.apiKey});
  
  Future<WeatherModel> fetchWeather(String cityName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?q=$cityName&appid=$apiKey'),
      );
      
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
  
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey'),
      );
      
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
