import 'package:climora/services/weather_service.dart';
import 'package:climora/services/weather_music_settings.dart';

enum SongMood { relaxed, focus, energetic, happy, calm, sad }

class SongMetadata {
  final String id;
  final String title;
  final String artist;
  final String assetPath;
  final List<String> genres;
  final List<String> languages;
  final Set<SongMood> moods;
  final Set<WeatherTrigger> weatherTriggers;
  final Set<TimeRange> idealTimeRanges;

  SongMetadata({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.genres,
    required this.languages,
    required this.moods,
    this.weatherTriggers = const {},
    this.idealTimeRanges = const {},
  });
}

class RecommendationEngine {
  final List<SongMetadata> _library = [
    SongMetadata(
      id: 'lofi_rain_1',
      title: 'Rainy Day Beat',
      artist: 'Climora Ambient',
      assetPath: 'assets/music/lofi_rain.mp3',
      genres: ['lo-fi', 'melody'],
      languages: ['English'],
      moods: {SongMood.relaxed, SongMood.focus},
      weatherTriggers: {WeatherTrigger.rainy, WeatherTrigger.cloudy},
      idealTimeRanges: {TimeRange.evening, TimeRange.night},
    ),
    SongMetadata(
      id: 'sun_energy_1',
      title: 'Morning Glow',
      artist: 'Solaris',
      assetPath: 'assets/music/morning_glow.mp3',
      genres: ['energetic', 'melody'],
      languages: ['Tamil'],
      moods: {SongMood.energetic, SongMood.happy},
      weatherTriggers: {WeatherTrigger.sunny, WeatherTrigger.clear},
      idealTimeRanges: {TimeRange.morning, TimeRange.afternoon},
    ),
    SongMetadata(
      id: 'classic_calm_1',
      title: 'Nocturne in C',
      artist: 'Classical Ensemble',
      assetPath: 'assets/music/nocturne.mp3',
      genres: ['classical'],
      languages: ['None'],
      moods: {SongMood.calm, SongMood.relaxed},
      weatherTriggers: {WeatherTrigger.clear, WeatherTrigger.foggy},
      idealTimeRanges: {TimeRange.night},
    ),
    SongMetadata(
      id: 'hindi_soft_1',
      title: 'Dil Se',
      artist: 'Aria',
      assetPath: 'assets/music/dil_se.mp3',
      genres: ['melody'],
      languages: ['Hindi'],
      moods: {SongMood.sad, SongMood.calm},
      weatherTriggers: {WeatherTrigger.windy, WeatherTrigger.cloudy},
      idealTimeRanges: {TimeRange.evening},
    ),
  ];

  List<SongMetadata> getRecommendations({
    required WeatherData weather,
    required WeatherMusicSettings settings,
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final currentHour = now.hour;

    // Determine current TimeRange
    TimeRange currentTR;
    if (currentHour >= 5 && currentHour < 12) {
      currentTR = TimeRange.morning;
    } else if (currentHour >= 12 && currentHour < 17) {
      currentTR = TimeRange.afternoon;
    } else if (currentHour >= 17 && currentHour < 21) {
      currentTR = TimeRange.evening;
    } else {
      currentTR = TimeRange.night;
    }

    // Determine likely weather triggers from data
    final activeTriggers = <WeatherTrigger>{};
    if ((weather.precipitation ?? 0) > 0.5) {
      activeTriggers.add(WeatherTrigger.rainy);
    }
    if (weather.cloudiness > 70) {
      activeTriggers.add(WeatherTrigger.cloudy);
    }
    if (weather.windSpeed > 8) {
      activeTriggers.add(WeatherTrigger.windy);
    }
    if (weather.temp > 30) {
      activeTriggers.add(WeatherTrigger.sunny);
    }
    if (weather.cloudiness < 15) {
      activeTriggers.add(WeatherTrigger.clear);
    }

    // Correctly process the library and return scored results
    final scored = _library
        .where((song) {
          if (settings.languages.isNotEmpty &&
              !song.languages.any((l) => settings.languages.contains(l)) &&
              !song.languages.contains('None')) {
            return false;
          }
          if (settings.genres.isNotEmpty &&
              !song.genres.any((g) => settings.genres.contains(g))) {
            return false;
          }
          return true;
        })
        .map((song) {
          double score = 1.0;
          if (song.weatherTriggers.any((t) => activeTriggers.contains(t))) {
            score += 2.0;
          }
          if (song.idealTimeRanges.contains(currentTR)) {
            score += 1.5;
          }
          if (settings.timeRanges.contains(currentTR)) {
            score += 0.5;
          }
          return _ScoredSong(song, score);
        })
        .toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((s) => s.song).toList();
  }
}

class _ScoredSong {
  final SongMetadata song;
  final double score;
  _ScoredSong(this.song, this.score);
}
