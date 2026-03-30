import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/weather_theme.dart';

class ThemeCacheService {
  static const String _cachedThemeKey = 'cached_weather_theme';
  
  Future<void> cacheTheme(WeatherTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    final themeData = {
      'name': theme.name,
      // Store necessary theme properties
    };
    await prefs.setString(_cachedThemeKey, json.encode(themeData));
  }
  
  Future<WeatherTheme?> getCachedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_cachedThemeKey);
    
    if (themeString != null) {
      final themeData = json.decode(themeString);
      // Reconstruct theme from cached data
      return WeatherTheme.themes.values.firstWhere(
        (theme) => theme.name == themeData['name'],
        orElse: () => WeatherTheme.themes[WeatherType.cloudy]!,
      );
    }
    return null;
  }
}
