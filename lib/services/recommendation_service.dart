import 'weather_service.dart';
import 'emotion_service.dart';
import 'weather_utils.dart';

class Recommendation {
  final String songAsset; // e.g., assets/music/calm_1.mp3
  final double volume; // 0..1
  final double speed; // playback rate
  final List<String> ambientKeys; // ambient suggestions

  Recommendation({required this.songAsset, required this.volume, required this.speed, required this.ambientKeys});
}

class RecommendationService {
  // Very simple rule-based recommender for prototype
  Recommendation recommend({EmotionResult? emotion, double vocalLevel = 0.0, WeatherData? weather}) {
    final label = (emotion?.label ?? 'neutral').toLowerCase();
    final score = emotion?.score ?? 0.5;

    // Base choices
    String song = 'assets/music/neutral_1.mp3';
    double volume = 0.6;
    double speed = 1.0;
    final List<String> ambient = <String>[];

    // Weather-aware modifiers
    double? comfort;
    final precipClass = weather != null ? ClimateIndices.precipitationIntensity(weather.precipitation ?? 0.0) : 'none';
    if (weather != null) {
      comfort = ClimateIndices.comfortIndex(weather.temp, weather.humidity, weather.windSpeed);
      ambient.addAll(ClimateIndices.suggestAmbientSounds(weather));
    }

    // Emotion -> base selection
    if (label.contains('sad') || label == 'negative') {
      song = 'assets/music/calming_1.mp3';
      volume = 0.5 + (0.2 * score);
      speed = 0.92;
      ambient.add('soft_pad');
    } else if (label.contains('happy') || label == 'positive') {
      song = 'assets/music/uplift_1.mp3';
      volume = 0.6 + (0.25 * (score - 0.5).abs());
      speed = 1.05 + (0.15 * (score - 0.5));
      ambient.add('bright_guitar');
    } else if (label.contains('stress') || label.contains('anx')) {
      song = 'assets/music/slow_pad.mp3';
      volume = 0.45 + (0.1 * (1 - score));
      speed = 0.88;
      ambient.add('breathing_pad');
    } else {
      // neutral/fallback
      song = 'assets/music/neutral_1.mp3';
      volume = 0.55;
      speed = 1.0;
    }

    // Comfort adjustments: if comfort low, prefer warmer/cozy tracks and slightly slower
    if (comfort != null && comfort < 45.0) {
      // colder/uncomfortable: calmer slower
      song = 'assets/music/cozy_indoor.mp3';
      speed = (speed * 0.95).clamp(0.8, 1.0);
      ambient.add('cozy_fire');
    }

    // Precipitation overrides: heavy rain -> cozy indoor or slow pad
    if (precipClass == 'heavy') {
      song = 'assets/music/cozy_indoor.mp3';
      volume = (volume * 0.9).clamp(0.3, 1.0);
      ambient.insert(0, 'heavy_rain');
    }

    // Vocal environment: noisy -> favor ambient mixes and reduce main music volume
    if (vocalLevel > 50.0) {
      volume = (volume * 0.65).clamp(0.15, 1.0);
      // emphasize ambient keys already in list
      if (!ambient.contains('park_ambience')) ambient.add('park_ambience');
    }

    // Deduplicate ambient list while preserving order
    final ambientKeys = <String>[];
    for (final a in ambient) {
      if (!ambientKeys.contains(a)) ambientKeys.add(a);
    }

    return Recommendation(songAsset: song, volume: double.parse(volume.toStringAsFixed(2)), speed: double.parse(speed.toStringAsFixed(2)), ambientKeys: ambientKeys);
  }
}
