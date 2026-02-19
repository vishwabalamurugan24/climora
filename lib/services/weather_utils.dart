import 'dart:math';
import 'weather_service.dart';

class ClimateIndices {
  // Compute heat index in Celsius using NOAA formula (convert to F, compute, convert back)
  static double heatIndexC(double tempC, double relHumidity) {
    final tF = tempC * 9 / 5 + 32;
    final r = relHumidity;
    final hiF = -42.379 + 2.04901523 * tF + 10.14333127 * r - 0.22475541 * tF * r - 6.83783e-3 * pow(tF, 2) - 5.481717e-2 * pow(r, 2) + 1.22874e-3 * pow(tF, 2) * r + 8.5282e-4 * tF * pow(r, 2) - 1.99e-6 * pow(tF, 2) * pow(r, 2);
    return (hiF - 32) * 5 / 9;
  }

  // Wind chill (C) using Canadian formula: T in C, v in km/h
  static double windChillC(double tempC, double windSpeedMps) {
    final v = windSpeedMps * 3.6; // km/h
    if (v < 4.8 || tempC > 10) return tempC; // wind chill not significant
    final wc = 13.12 + 0.6215 * tempC - 11.37 * pow(v, 0.16) + 0.3965 * tempC * pow(v, 0.16);
    return wc;
  }

  // Classify precipitation intensity (mm per hour)
  static String precipitationIntensity(double? mmPerHour) {
    if (mmPerHour == null || mmPerHour <= 0.0) return 'none';
    if (mmPerHour < 2.5) return 'light';
    if (mmPerHour < 7.6) return 'moderate';
    return 'heavy';
  }

  // Simple comfort index 0..100 (higher better)
  static double comfortIndex(double tempC, int humidity, double windSpeedMps) {
    double score = 100.0;
    score -= (tempC - 21).abs() * 3.0; // penalty per degree from 21C
    score -= humidity * 0.2; // humidity penalty
    if (tempC >= 25 && windSpeedMps >= 3.0) score += 5.0; // wind cooling helps warm days
    score = score.clamp(0.0, 100.0);
    return double.parse(score.toStringAsFixed(1));
  }

  // Map weather to ambient sound suggestions
  static List<String> suggestAmbientSounds(WeatherData w) {
    final List<String> out = [];
    final precipClass = precipitationIntensity(w.precipitation ?? 0.0);
    final hour = DateTime.now().hour;
    final isNight = (hour >= 20 || hour < 6);

    if (precipClass == 'heavy') {
      out.add('heavy_rain');
      out.add('cozy_indoor');
      return out;
    }
    if (precipClass == 'moderate') {
      out.add('rain');
      out.add('soft_piano');
    } else if (precipClass == 'light') {
      out.add('light_rain');
      out.add('ambient_pad');
    }

    if (w.windSpeed > 8.0) {
      out.add('wind');
    }

    if (w.cloudiness < 30 && precipClass == 'none' && w.temp >= 12 && w.temp <= 28) {
      out.add('birds');
      out.add('park_ambience');
    }

    if (isNight) {
      out.add('night_ambience');
    }

    if (out.isEmpty) out.add('neutral_ambience');
    return out;
  }
}
