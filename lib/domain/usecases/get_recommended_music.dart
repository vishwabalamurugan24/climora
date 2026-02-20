import 'package:climora/domain/entities/song_entity.dart';
import 'package:climora/domain/repositories/music_repository.dart';
import 'package:climora/domain/repositories/weather_repository.dart';

class GetRecommendedMusic {
  final MusicRepository _musicRepo;
  final WeatherRepository _weatherRepo;

  GetRecommendedMusic(this._musicRepo, this._weatherRepo);

  Future<List<SongEntity>> execute({required String emotionLabel}) async {
    final weather = await _weatherRepo.getCurrentWeather();

    // Convert WeatherEntity triggers to strings compatible with RecommendationEngine logic
    List<String> activeTriggers = [];
    if (weather.temperature > 30) activeTriggers.add('sunny');
    if (weather.precipitation > 0) activeTriggers.add('rainy');
    if (weather.description.toLowerCase().contains('clear')) {
      activeTriggers.add('clear');
    }

    final allSongs = await _musicRepo.getAllSongs();

    // Basic scoring/filtering integration for now
    return allSongs
        .where(
          (s) => s.weatherTriggers.any(
            (t) => activeTriggers.contains(t.name.toLowerCase()),
          ),
        )
        .toList();
  }
}
