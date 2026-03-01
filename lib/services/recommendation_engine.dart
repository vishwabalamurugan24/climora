import 'package:flutter/foundation.dart';
class SongMetadata {
  final String id;
  final String title;
  final String artist;
  final String assetPath;
  SongMetadata({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetPath,
  });
}

class RecommendationEngine {
  /// Generates a personalized music playlist based on the user's current mood.
  Future<List<SongMetadata>> getPersonalizedMusic({
    required String currentMood,
  }) async {
    debugPrint("Using fallback for mood '$currentMood'.");
    return await _getFallbackMusic(currentMood);
  }

  /// Provides a generic, rule-based music recommendation as a fallback.
  Future<List<SongMetadata>> _getFallbackMusic(String mood) async {
    String category;
    switch (mood.toLowerCase()) {
      case 'stressed':
      case 'sad':
      case 'relaxed':
        category = 'calm';
        break;
      case 'happy':
      case 'energetic':
        category = 'energetic';
        break;
      case 'romantic':
        category = 'romantic';
        break;
      default:
        category = 'instrumental';
        break;
    }

    debugPrint("Fallback: Recommending '$category' category for '$mood' mood.");
    return [
      SongMetadata(
        id: '1',
        title: 'Fallback Track',
        artist: 'Climora',
        assetPath: 'assets/music/${category}_1.mp3',
      ),
    ];
  }

  List<SongMetadata> getRecommendations({
    required dynamic weather,
    required dynamic settings,
  }) {
    return [
      SongMetadata(
        id: '1',
        title: 'Ambient Track',
        artist: 'Climora',
        assetPath: 'assets/music/neutral_1.mp3',
      ),
    ];
  }
}
