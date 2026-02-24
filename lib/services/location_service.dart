import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:climora/domain/entities/place_recommendation.dart';

class LocationService {
  final String _baseUrl = 'http://localhost:8000';

  Future<List<PlaceRecommendation>> getNearbyMoodSpots({
    required double lat,
    required double lon,
    required String targetVibe,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/map/spots?lat=$lat&lon=$lon&vibe=$targetVibe'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List spots = data['spots'] ?? [];
        return spots
            .map(
              (s) => PlaceRecommendation(
                id: s['id'],
                name: s['name'],
                description: 'Powered by Climora Cloud',
                latitude: (s['latitude'] as num).toDouble(),
                longitude: (s['longitude'] as num).toDouble(),
                vibe: s['vibe'],
                category: s['category'],
              ),
            )
            .toList();
      }
    } catch (e) {
      // Fallback to mock data on error/timeout
      print('Backend error, falling back to mock: $e');
    }

    // Existing Mock logic
    return [
      PlaceRecommendation(
        id: 'spot_1',
        name: 'Zen Garden Path (Local)',
        description: 'A quiet walking path with bamboo trees.',
        latitude: lat + 0.005,
        longitude: lon + 0.005,
        vibe: 'calm',
        category: 'Park',
      ),
      PlaceRecommendation(
        id: 'spot_2',
        name: 'Electric Street Coffee (Local)',
        description: 'High-energy espresso bar with lo-fi beats.',
        latitude: lat - 0.003,
        longitude: lon + 0.002,
        vibe: 'energetic',
        category: 'Cafe',
      ),
      PlaceRecommendation(
        id: 'spot_3',
        name: 'Silent Library Annex (Local)',
        description: 'Perfect for deep focus and reading.',
        latitude: lat + 0.001,
        longitude: lon - 0.004,
        vibe: 'focus',
        category: 'Education',
      ),
    ].where((p) => p.vibe == targetVibe || targetVibe == 'any').toList();
  }
}
