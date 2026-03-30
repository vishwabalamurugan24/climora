import 'package:flutter/material.dart';

enum WeatherType {
  sunny,
  rainy,
  cloudy,
  snowy,
  stormy,
  night,
  foggy,
}

class WeatherTheme {
  final String name;
  final Gradient backgroundGradient;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color cardColor;
  final Color accentColor;
  final String animationAsset;
  final List<Color> particleColors;

  WeatherTheme({
    required this.name,
    required this.backgroundGradient,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.cardColor,
    required this.accentColor,
    required this.animationAsset,
    required this.particleColors,
  });

  static Map<WeatherType, WeatherTheme> get themes => {
    WeatherType.sunny: WeatherTheme(
      name: 'Sunny',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFD89C),
          Color(0xFFFFB347),
          Color(0xFFFF9F4A),
        ],
        stops: [0.0, 0.6, 1.0],
      ),
      primaryColor: Color(0xFFFF8C42),
      secondaryColor: Color(0xFFFFB347),
      textColor: Color(0xFF3C2A1F),
      cardColor: Colors.white.withOpacity(0.9),
      accentColor: Color(0xFFFF6B35),
      animationAsset: 'assets/animations/sunny.json',
      particleColors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    ),
    
    WeatherType.rainy: WeatherTheme(
      name: 'Rainy',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2C3E50),
          Color(0xFF3498DB),
          Color(0xFF2980B9),
        ],
      ),
      primaryColor: Color(0xFF3498DB),
      secondaryColor: Color(0xFF5DADE2),
      textColor: Colors.white,
      cardColor: Colors.white.withOpacity(0.15),
      accentColor: Color(0xFF74B9FF),
      animationAsset: 'assets/animations/rainy.json',
      particleColors: [Color(0xFF74B9FF), Color(0xFFA9D6FF)],
    ),
    
    WeatherType.cloudy: WeatherTheme(
      name: 'Cloudy',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF95A5A6),
          Color(0xFF7F8C8D),
          Color(0xFF6C7A89),
        ],
      ),
      primaryColor: Color(0xFF7F8C8D),
      secondaryColor: Color(0xFF95A5A6),
      textColor: Colors.white,
      cardColor: Colors.white.withOpacity(0.2),
      accentColor: Color(0xFFBDC3C7),
      animationAsset: 'assets/animations/cloudy.json',
      particleColors: [Color(0xFFECF0F1), Color(0xFFBDC3C7)],
    ),
    
    WeatherType.night: WeatherTheme(
      name: 'Night',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0F2027),
          Color(0xFF203A43),
          Color(0xFF2C5364),
        ],
      ),
      primaryColor: Color(0xFF2C3E50),
      secondaryColor: Color(0xFF34495E),
      textColor: Colors.white,
      cardColor: Colors.white.withOpacity(0.1),
      accentColor: Color(0xFF5DADE2),
      animationAsset: 'assets/animations/night.json',
      particleColors: [Color(0xFFFFFF00), Color(0xFFFFE4B5)],
    ),
    
    WeatherType.stormy: WeatherTheme(
      name: 'Stormy',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1A1A2E),
          Color(0xFF16213E),
          Color(0xFF0F3460),
        ],
      ),
      primaryColor: Color(0xFF4A4E69),
      secondaryColor: Color(0xFF6C757D),
      textColor: Colors.white,
      cardColor: Colors.white.withOpacity(0.12),
      accentColor: Color(0xFFE94560),
      animationAsset: 'assets/animations/stormy.json',
      particleColors: [Color(0xFFE94560), Color(0xFFFF6B6B)],
    ),
    
    WeatherType.snowy: WeatherTheme(
      name: 'Snowy',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE3F2FD),
          Color(0xFFBBDEFB),
          Color(0xFF90CAF9),
        ],
      ),
      primaryColor: Color(0xFF64B5F6),
      secondaryColor: Color(0xFF90CAF9),
      textColor: Color(0xFF1E3C72),
      cardColor: Colors.white.withOpacity(0.9),
      accentColor: Color(0xFF42A5F5),
      animationAsset: 'assets/animations/snowy.json',
      particleColors: [Colors.white, Color(0xFFE3F2FD)],
    ),
    
    WeatherType.foggy: WeatherTheme(
      name: 'Foggy',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFBDBDBD),
          Color(0xFF9E9E9E),
          Color(0xFF757575),
        ],
      ),
      primaryColor: Color(0xFF9E9E9E),
      secondaryColor: Color(0xFFBDBDBD),
      textColor: Colors.white,
      cardColor: Colors.white.withOpacity(0.25),
      accentColor: Color(0xFFE0E0E0),
      animationAsset: 'assets/animations/foggy.json',
      particleColors: [Color(0xFFE0E0E0), Colors.white],
    ),
  };
}

WeatherType getWeatherType(String condition) {
  condition = condition.toLowerCase();
  
  if (condition.contains('clear') || condition.contains('sun')) return WeatherType.sunny;
  if (condition.contains('rain') || condition.contains('drizzle')) return WeatherType.rainy;
  if (condition.contains('cloud')) return WeatherType.cloudy;
  if (condition.contains('snow')) return WeatherType.snowy;
  if (condition.contains('thunder') || condition.contains('storm')) return WeatherType.stormy;
  if (condition.contains('fog') || condition.contains('mist')) return WeatherType.foggy;
  if (condition.contains('night')) return WeatherType.night;
  
  return WeatherType.cloudy; // default
}
