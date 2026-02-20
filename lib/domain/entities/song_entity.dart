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
}
