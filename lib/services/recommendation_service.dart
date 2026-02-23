import 'weather_service.dart';
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

  // Rule-based recommender driven by mood keywords, weather data, and settings
  Recommendation recommend({
    required WeatherData weather,
    required WeatherMusicSettings settings,
    String mood = 'neutral',
    double moodScore = 0.5,
    double vocalLevel = 0.0,
  }) {
    // Determine recommendations through the engine
    final suggestions = _engine.getRecommendations(
      weather: weather,
      settings: settings,
      // Note: EmotionResult dependency removed in engine or handled as null
    );

    final SongMetadata? topSong = suggestions.isNotEmpty
        ? suggestions.first
        : null;

    // Default fallback
    String songAsset = topSong?.assetPath ?? 'assets/music/neutral_1.mp3';
    double volume = 0.6;
    double speed = 1.0;
    final List<String> ambient = ClimateIndices.suggestAmbientSounds(weather);

    // Weather-aware modifiers
    final comfort = ClimateIndices.comfortIndex(
      weather.temp,
      weather.humidity,
      weather.windSpeed,
    );

    // Mood keyword overrides (matching previous simplified logic)
    final label = mood.toLowerCase();
    final score = moodScore;

    if (label.contains('sad') || label == 'negative') {
      if (topSong == null) songAsset = 'assets/music/calming_1.mp3';
      volume = (0.5 + (0.2 * score)).clamp(0.0, 1.0);
      speed = 0.92;
      ambient.add('soft_pad');
    } else if (label.contains('happy') || label == 'positive') {
      if (topSong == null) songAsset = 'assets/music/uplift_1.mp3';
      volume = (0.6 + (0.25 * (score - 0.5).abs())).clamp(0.0, 1.0);
      speed = 1.05 + (0.15 * (score - 0.5));
      ambient.add('bright_guitar');
    } else if (label.contains('stress') || label.contains('anx')) {
      if (topSong == null) songAsset = 'assets/music/slow_pad.mp3';
      volume = (0.45 + (0.1 * (1 - score))).clamp(0.0, 1.0);
      speed = 0.88;
      ambient.add('breathing_pad');
    }

    // Comfort adjustments
    if (comfort < 45.0) {
      if (topSong == null) songAsset = 'assets/music/cozy_indoor.mp3';
      speed = (speed * 0.95).clamp(0.8, 1.0);
      ambient.add('cozy_fire');
    }

    // Precipitation overrides: heavy rain -> cozy indoor or slow pad
    final precipClass = ClimateIndices.precipitationIntensity(
      weather.precipitation ?? 0.0,
    );
    if (precipClass == 'heavy') {
      if (topSong == null) songAsset = 'assets/music/cozy_indoor.mp3';
      volume = (volume * 0.9).clamp(0.3, 1.0);
      ambient.insert(0, 'heavy_rain');
    }

    // Vocal environment: noisy -> favor ambient mixes and reduce main music volume
    if (vocalLevel > 50.0) {
      volume = (volume * 0.65).clamp(0.15, 1.0);
      if (!ambient.contains('park_ambience')) ambient.add('park_ambience');
    }

    // Deduplicate ambient list
    final ambientKeys = ambient.toSet().toList();

    return Recommendation(
      songAsset: songAsset,
      volume: double.parse(volume.toStringAsFixed(2)),
      speed: double.parse(speed.toStringAsFixed(2)),
      ambientKeys: ambientKeys,
      songMetadata: topSong,
    );
  }
}
