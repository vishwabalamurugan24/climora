import 'package:equatable/equatable.dart';
import 'package:climora/services/weather_music_settings.dart';

class SongEntity extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String assetPath;
  final List<String> genres;
  final List<String> languages;
  final List<SongMood> moods;
  final List<WeatherTrigger> weatherTriggers;
  final List<TimeRange> idealTimeRanges;

  const SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.genres,
    required this.languages,
    required this.moods,
    required this.weatherTriggers,
    required this.idealTimeRanges,
  });

  @override
  List<Object?> get props => [id, title, artist, assetPath];

  factory SongEntity.fromJson(Map<String, dynamic> json) {
    return SongEntity(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      assetPath: json['assetPath'],
      genres: List<String>.from(json['genres']),
      languages: List<String>.from(json['languages']),
      moods: (json['moods'] as List).map((e) => SongMood.values.firstWhere((element) => element.toString().split('.').last == e)).toList(),
      weatherTriggers: (json['weatherTriggers'] as List).map((e) => WeatherTrigger.values.firstWhere((element) => element.toString().split('.').last == e)).toList(),
      idealTimeRanges: (json['idealTimeRanges'] as List).map((e) => TimeRange.values.firstWhere((element) => element.toString().split('.').last == e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'assetPath': assetPath,
      'genres': genres,
      'languages': languages,
      'moods': moods.map((e) => e.toString().split('.').last).toList(),
      'weatherTriggers': weatherTriggers.map((e) => e.toString().split('.').last).toList(),
      'idealTimeRanges': idealTimeRanges.map((e) => e.toString().split('.').last).toList(),
    };
  }
}
