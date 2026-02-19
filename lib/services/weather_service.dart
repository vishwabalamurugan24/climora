import 'dart:convert';
import 'dart:io';
import '../shims/geolocator.dart';
import '../shims/shared_preferences.dart';

class WeatherData {
  final double temp;
  final int humidity;
  final double windSpeed;
  final int cloudiness;
  final String description;
  final double? precipitation; // mm for last hour if available

  WeatherData({
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
    required this.description,
    this.precipitation,
  });

  factory WeatherData.fromJson(Map<String, dynamic> j) {
    final weather = (j['weather'] as List).isNotEmpty ? j['weather'][0] : null;
    double? precip;
    if (j.containsKey('rain') && j['rain'] is Map) {
      precip = (j['rain']['1h'] ?? j['rain']['3h'])?.toDouble();
    }
    return WeatherData(
      temp: (j['main']?['temp'] ?? 0).toDouble(),
      humidity: (j['main']?['humidity'] ?? 0).toInt(),
      windSpeed: (j['wind']?['speed'] ?? 0).toDouble(),
      cloudiness: (j['clouds']?['all'] ?? 0).toInt(),
      description: weather != null ? (weather['description'] ?? '') : '',
      precipitation: precip,
    );
  }
}

class WeatherService {
  final String? _apiKey = Platform.environment['OPENWEATHER_API_KEY'];
  static const _cacheKey = '_last_weather_raw';

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  /// Fetch weather for the current device location. If no API key is configured
  /// and [allowMock] is true, returns a cached value or a reasonable mock WeatherData.
  Future<WeatherData?> getWeatherForCurrentLocation({bool allowMock = true}) async {
    try {
      final pos = await getCurrentPosition();
      if (_apiKey == null || _apiKey.isEmpty) {
        if (allowMock) {
          final cached = await loadLastWeather();
          return cached ?? _mockWeatherFor(pos.latitude, pos.longitude);
        }
        throw Exception('OPENWEATHER_API_KEY not set in environment');
      }
      return await fetchWeather(pos.latitude, pos.longitude);
    } catch (e) {
      final cached = await loadLastWeather();
      if (cached != null) return cached;
      if (allowMock) return _mockWeatherFor(0.0, 0.0);
      rethrow;
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<WeatherData> fetchWeather(double lat, double lon) async {
    if (_apiKey == null || _apiKey.isEmpty) throw Exception('OPENWEATHER_API_KEY not set in .env');

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': 'metric',
      'appid': _apiKey,
    });

    final client = HttpClient();
    final request = await client.getUrl(uri);
    final response = await request.close().timeout(const Duration(seconds: 12));
    final body = await response.transform(utf8.decoder).join();
    client.close();
    if (response.statusCode != 200) throw Exception('Weather API error: ${response.statusCode}');

    // cache raw response and timestamp for fallback
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, body);
      await prefs.setString('${_cacheKey}_ts', DateTime.now().toIso8601String());
    } catch (_) {}

    final j = jsonDecode(body) as Map<String, dynamic>;
    return WeatherData.fromJson(j);
  }

  /// Load last cached weather JSON if available.
  Future<WeatherData?> loadLastWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null || raw.isEmpty) return null;
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return WeatherData.fromJson(j);
    } catch (_) {
      return null;
    }
  }

  /// Load last cached weather timestamp if available.
  Future<DateTime?> loadLastWeatherTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('${_cacheKey}_ts');
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    } catch (_) {
      return null;
    }
  }

  // Simple mock weather generator for prototype/demo when API key is missing.
  WeatherData _mockWeatherFor(double lat, double lon) {
    // mild default values
    return WeatherData(
      temp: 21.0,
      humidity: 50,
      windSpeed: 1.5,
      cloudiness: 20,
      description: 'Clear sky (mock)',
      precipitation: 0.0,
    );
  }
}
