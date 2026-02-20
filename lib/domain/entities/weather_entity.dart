import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final double temperature;
  final String description;
  final double humidity;
  final double windSpeed;
  final double precipitation;
  final String conditionCode;

  const WeatherEntity({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.conditionCode,
  });

  @override
  List<Object?> get props => [temperature, description, conditionCode];
}
