import 'package:climora/services/firestore_service.dart';

class RecommendationEngine {
  final FirestoreService _firestoreService = FirestoreService();

  /// Generates a personalized music playlist based on the user's current mood,
  /// leveraging their AI profile.
  Future<List<MusicTrack>> getPersonalizedMusic({
    required String currentMood,
  }) async {
    // 1. Attempt to get a recommendation from the AI profile first.
    final aiProfile = await _firestoreService.getAiProfile();

    if (aiProfile != null &&
        aiProfile.containsKey('bestMusicPerMood') &&
        (aiProfile['bestMusicPerMood'] as Map).containsKey(currentMood)) {
      final dynamic bestMusicData = aiProfile['bestMusicPerMood'][currentMood];

      if (bestMusicData is List && bestMusicData.isNotEmpty) {
        print("Found personalized recommendation in AI profile for mood: $currentMood");
        final trackIds = List<String>.from(bestMusicData);
        // Fetch the full track details for the recommended IDs.
        return await _firestoreService.getTracksByIds(trackIds);
      }
    }

    // 2. If no AI profile data is found for this mood, use a fallback.
    print("No AI profile data for mood '$currentMood'. Using fallback.");
    return await _getFallbackMusic(currentMood);
  }

  /// Provides a generic, rule-based music recommendation as a fallback.
  Future<List<MusicTrack>> _getFallbackMusic(String mood) {
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

    print("Fallback: Recommending '$category' category for '$mood' mood.");
    return _firestoreService.getTracksByCategory(category);
  }
}