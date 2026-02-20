import 'package:climora/domain/entities/place_recommendation.dart';

class LocationService {
  Future<List<PlaceRecommendation>> getNearbyMoodSpots({
    required double lat,
    required double lon,
    required String targetVibe,
  }) async {
    // Mocking API call results
    await Future.delayed(const Duration(seconds: 1));

    return [
      PlaceRecommendation(
        id: 'spot_1',
        name: 'Zen Garden Path',
        description: 'A quiet walking path with bamboo trees.',
        latitude: lat + 0.005,
        longitude: lon + 0.005,
        vibe: 'calm',
        category: 'Park',
      ),
      PlaceRecommendation(
        id: 'spot_2',
        name: 'Electric Street Coffee',
        description: 'High-energy espresso bar with lo-fi beats.',
        latitude: lat - 0.003,
        longitude: lon + 0.002,
        vibe: 'energetic',
        category: 'Cafe',
      ),
      PlaceRecommendation(
        id: 'spot_3',
        name: 'Silent Library Annex',
        description: 'Perfect for deep focus and reading.',
        latitude: lat + 0.001,
        longitude: lon - 0.004,
        vibe: 'focus',
        category: 'Education',
      ),
    ].where((p) => p.vibe == targetVibe || targetVibe == 'any').toList();
  }
}
