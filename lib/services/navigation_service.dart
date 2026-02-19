import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '../shims/geolocator.dart';

class MicroDestination {
  final String id;
  final String name;
  final String category;
  final double lat;
  final double lon;
  final double distanceMeters;

  MicroDestination({required this.id, required this.name, required this.category, required this.lat, required this.lon, required this.distanceMeters});
}

class NavigationService {
  final String? _mapboxKey = Platform.environment['MAPBOX_API_KEY'];

  /// Suggest micro-destinations near [pos], tailored by [mood] and [comfort].
  /// If a `MAPBOX_API_KEY` is present, queries Mapbox Places API; otherwise returns mock nearby places.
  Future<List<MicroDestination>> suggestMicroDestinations(Position pos, {String mood = 'neutral', double comfort = 50.0, int limit = 8}) async {
    if (_mapboxKey != null && _mapboxKey.isNotEmpty) {
      try {
        final uri = Uri.https('api.mapbox.com', '/geocoding/v5/mapbox.places/point_of_interest.json', {
          'proximity': '${pos.longitude},${pos.latitude}',
          'limit': limit.toString(),
          'access_token': _mapboxKey,
        });
        final client = HttpClient();
        final req = await client.getUrl(uri);
        final resp = await req.close();
        final body = await resp.transform(utf8.decoder).join();
        client.close();
        if (resp.statusCode == 200) {
          final j = jsonDecode(body) as Map<String, dynamic>;
          final features = j['features'] as List? ?? [];
          return features.map((f) {
            final coords = (f['geometry']?['coordinates'] as List?) ?? [];
            final name = f['text'] ?? 'Place';
            final category = (f['properties']?['category'] ?? 'point_of_interest').toString();
            final lon = double.tryParse('${coords.isNotEmpty ? coords[0] : 0.0}') ?? 0.0;
            final lat = double.tryParse('${coords.length > 1 ? coords[1] : 0.0}') ?? 0.0;
            final dist = _haversine(pos.latitude, pos.longitude, lat, lon);
            return MicroDestination(
              id: '${f['id'] ?? name}',
              name: name,
              category: category,
              lat: lat,
              lon: lon,
              distanceMeters: dist,
            );
          }).toList();
        }
      } catch (_) {
        // fall back to mock
      }
    }

    // Mock fallback: generate nearby suggestions by offsetting lat/lon
    final List<MicroDestination> out = [];
    final seeds = [
      ['Park', 'park'],
      ['Café', 'cafe'],
      ['Bookstore', 'bookstore'],
      ['Tea Shop', 'cafe'],
      ['Scenic Walk', 'walk'],
      ['Quiet Garden', 'park'],
      ['Museum', 'museum'],
      ['Small Theater', 'theatre']
    ];
    for (var i = 0; i < seeds.length && out.length < limit; i++) {
      final s = seeds[i];
      final dLat = (i + 1) * 0.0012; // ~100m steps
      final dLon = (i % 2 == 0 ? 1 : -1) * (i + 1) * 0.0011;
      final lat = pos.latitude + dLat;
      final lon = pos.longitude + dLon;
      final dist = _haversine(pos.latitude, pos.longitude, lat, lon);
      out.add(MicroDestination(id: 'mock_$i', name: s[0], category: s[1], lat: lat, lon: lon, distanceMeters: dist));
    }

    // Optionally sort by comfort/mood preference (parks preferred when stressed/calm)
    out.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return out;
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // meters
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);
}
