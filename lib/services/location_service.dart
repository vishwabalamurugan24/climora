import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:climora/domain/entities/place_recommendation.dart';

class LocationService {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<PlaceRecommendation>> getNearbyMoodSpots({
    required double lat,
    required double lon,
    required String targetVibe,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/map/locations'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List spots = data ?? [];
        return spots
            .map(
              (s) => PlaceRecommendation(
                id: s['id'],
                name: s['name'],
                description: 'Powered by Climora Cloud',
                latitude: (s['latitude'] as num).toDouble(),
                longitude: (s['longitude'] as num).toDouble(),
                vibe: 'any',
                category: 'any',
              ),
            )
            .toList();
      }
    } catch (e) {
      // Fallback to mock data on error/timeout
      log('Backend error, falling back to mock: $e');
    }

    final random = Random();
    double randomOffset() => (random.nextDouble() - 0.5) * 0.02;

    // Existing Mock logic
    return [
      PlaceRecommendation(
        id: 'spot_1',
        name: 'Zen Garden Path (Local)',
        description: 'A quiet walking path with bamboo trees.',
        latitude: lat + randomOffset(),
        longitude: lon + randomOffset(),
        vibe: 'calm',
        category: 'Park',
      ),
      PlaceRecommendation(
        id: 'spot_2',
        name: 'Electric Street Coffee (Local)',
        description: 'High-energy espresso bar with lo-fi beats.',
        latitude: lat + randomOffset(),
        longitude: lon + randomOffset(),
        vibe: 'energetic',
        category: 'Cafe',
      ),
      PlaceRecommendation(
        id: 'spot_3',
        name: 'Silent Library Annex (Local)',
        description: 'Perfect for deep focus and reading.',
        latitude: lat + randomOffset(),
        longitude: lon + randomOffset(),
        vibe: 'focus',
        category: 'Education',
      ),
    ].where((p) => p.vibe == targetVibe || targetVibe == 'any').toList();
  }
}
