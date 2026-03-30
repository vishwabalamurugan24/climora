import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../theme/weather_theme.dart';
import '../services/theme_cache_service.dart';

class WeatherThemeProvider extends ChangeNotifier {
  WeatherTheme _currentTheme = WeatherTheme.themes[WeatherType.cloudy]!;
  WeatherModel? _currentWeather;
  final ThemeCacheService _cacheService = ThemeCacheService();
  
  WeatherTheme get currentTheme => _currentTheme;
  WeatherModel? get currentWeather => _currentWeather;

  WeatherThemeProvider() {
    loadCachedThemeIfAvailable();
  }

  void updateTheme(WeatherModel weather) {
    _currentWeather = weather;
    final weatherType = getWeatherType(weather.condition);
    final newTheme = WeatherTheme.themes[weatherType]!;
    
    if (_currentTheme.name != newTheme.name) {
      _currentTheme = newTheme;
      notifyListeners();
    }
  }

  Future<void> updateThemeWithCache(WeatherModel weather) async {
    updateTheme(weather);
    await _cacheService.cacheTheme(_currentTheme);
  }

  Future<void> loadCachedThemeIfAvailable() async {
    final cached = await _cacheService.getCachedTheme();
    if (cached != null) {
      _currentTheme = cached;
      notifyListeners();
    }
  }
  
  // Fallback to cached theme
  void loadCachedTheme(WeatherTheme cachedTheme) {
    _currentTheme = cachedTheme;
    notifyListeners();
  }
}
