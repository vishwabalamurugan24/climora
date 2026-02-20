import 'weather_service.dart';
import 'emotion_service.dart';
import 'weather_utils.dart';
import 'recommendation_engine.dart';
import 'weather_music_settings.dart';

class Recommendation {
  final String songAsset; // e.g., assets/music/calm_1.mp3
  final double volume; // 0..1
  final double speed; // playback rate
  final List<String> ambientKeys; // ambient suggestions
  final SongMetadata? songMetadata; // Added for more details

  Recommendation({
    required this.songAsset,
    required this.volume,
    required this.speed,
    required this.ambientKeys,
    this.songMetadata,
  });
}

class RecommendationService {
  final RecommendationEngine _engine = RecommendationEngine();

  Recommendation recommend({
    required WeatherData weather,
    required WeatherMusicSettings settings,
    EmotionResult? emotion,
  }) {
    final suggestions = _engine.getRecommendations(
      weather: weather,
      settings: settings,
      emotion: emotion,
    );

    final SongMetadata? topSong = suggestions.isNotEmpty
        ? suggestions.first
        : null;

    // Default fallback
    String songAsset = topSong?.assetPath ?? 'assets/music/neutral_1.mp3';
    double volume = 0.6;
    double speed = 1.0;
    final List<String> ambient = ClimateIndices.suggestAmbientSounds(weather);

    // Dynamic modifiers based on weather/emotion similar to original logic
    final precip = weather.precipitation ?? 0.0;
    if (precip > 5.0) {
      speed = 0.9;
      volume = 0.5;
    }

    return Recommendation(
      songAsset: songAsset,
      volume: volume,
      speed: speed,
      ambientKeys: ambient,
      songMetadata: topSong,
    );
  }
}
