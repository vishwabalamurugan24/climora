import 'package:flutter/material.dart';
import '../theme/weather_themes.dart';
import '../animations/weather_animations.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  ThemeData _currentTheme = WeatherThemes.sunnyTheme;
  Widget _currentAnimation = WeatherAnimations.sunnyAnimation();

  ThemeData get currentTheme => _currentTheme;
  Widget get currentAnimation => _currentAnimation;

  void updateWeather(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'sunny':
        _currentTheme = WeatherThemes.sunnyTheme;
        _currentAnimation = WeatherAnimations.sunnyAnimation();
        break;
      case 'rainy':
        _currentTheme = WeatherThemes.rainyTheme;
        _currentAnimation = WeatherAnimations.rainyAnimation();
        break;
      case 'snowy':
        _currentTheme = WeatherThemes.snowyTheme;
        _currentAnimation = WeatherAnimations.snowyAnimation();
        break;
      case 'cloudy':
        _currentTheme = WeatherThemes.cloudyTheme;
        _currentAnimation = WeatherAnimations.cloudyAnimation();
        break;
      default:
        _currentTheme = WeatherThemes.sunnyTheme;
        _currentAnimation = WeatherAnimations.sunnyAnimation();
    }
    notifyListeners();
  }

  Future<void> fetchAndUpdateWeather(String city) async {
    try {
      String weatherCondition = await _weatherService.fetchWeatherCondition(
        city,
      );
      updateWeather(weatherCondition);
    } catch (e) {
      // Handle errors (e.g., show a default theme or log the error)
      updateWeather('sunny');
    }
  }
}
