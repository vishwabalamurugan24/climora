import 'package:equatable/equatable.dart';

abstract class AuraEvent extends Equatable {
  const AuraEvent();

  @override
  List<Object> get props => [];
}

class ContextChanged extends AuraEvent {
  final String? weatherDescription;
  final String? emotionLabel;

  const ContextChanged({this.weatherDescription, this.emotionLabel});

  @override
  List<Object> get props => [weatherDescription ?? '', emotionLabel ?? ''];
}

class SyncToCloud extends AuraEvent {
  final String userId;
  final String? vibe;
  final double? lat;
  final double? lon;
  final String? weatherCondition;
  final double? temperature;

  const SyncToCloud({
    required this.userId,
    this.vibe,
    this.lat,
    this.lon,
    this.weatherCondition,
    this.temperature,
  });

  @override
  List<Object> get props => [
    userId,
    vibe ?? '',
    lat ?? 0.0,
    lon ?? 0.0,
    weatherCondition ?? '',
    temperature ?? 0.0,
  ];
}
