import 'package:climora/domain/entities/weather_entity.dart';
import 'package:climora/domain/repositories/weather_repository.dart';
import 'package:climora/services/weather_service.dart';

class OpenWeatherRepository implements WeatherRepository {
  final WeatherService
  _service; // Reusing existing service as a data source wrapper

  OpenWeatherRepository(this._service);

  @override
  Future<WeatherEntity> getCurrentWeather() async {
    final data = await _service.getWeatherForCurrentLocation(allowMock: true);
    if (data == null) throw Exception('Weather data unavailable');

    return WeatherEntity(
      temperature: data.temp.toDouble(),
      description: data.description,
      humidity: data.humidity.toDouble(),
      windSpeed: data.windSpeed.toDouble(),
      precipitation: data.precipitation?.toDouble() ?? 0.0,
      conditionCode: _mapDescriptionToCode(data.description),
    );
  }

  @override
  Future<WeatherEntity?> getCachedWeather() async {
    // SharedPrefs logic inside WeatherService can be exposed here if needed
    return null;
  }

  String _mapDescriptionToCode(String desc) {
    // Simple mapping for now
    if (desc.toLowerCase().contains('rain')) return 'rain';
    if (desc.toLowerCase().contains('cloud')) return 'cloud';
    return 'clear';
  }
}
