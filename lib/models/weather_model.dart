class WeatherModel {
  final String condition;
  final double temperature;
  final String cityName;
  final int humidity;
  final double windSpeed;
  final int timestamp;

  WeatherModel({
    required this.condition,
    required this.temperature,
    required this.cityName,
    required this.humidity,
    required this.windSpeed,
    required this.timestamp,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];

    return WeatherModel(
      condition: weather['main'].toLowerCase(),
      temperature: (main['temp'] - 273.15).toDouble(), // Convert Kelvin to Celsius
      cityName: json['name'],
      humidity: main['humidity'],
      windSpeed: wind['speed'].toDouble(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
