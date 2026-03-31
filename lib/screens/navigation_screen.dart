import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:climora/core/theme/app_theme.dart';
import 'package:climora/services/location_service.dart';
import 'package:climora/domain/entities/place_recommendation.dart';
import '../widgets/climora_bottom_nav.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final LocationService _locationService = LocationService();
  List<PlaceRecommendation> _spots = [];
  bool _isLoading = true;
  final LatLng _currentLocation = const LatLng(
    12.9716,
    77.5946,
  ); // Default to Bengaluru

  @override
  void initState() {
    super.initState();
    _fetchSpots();
  }

  Future<void> _fetchSpots() async {
    final spots = await _locationService.getNearbyMoodSpots(
      lat: _currentLocation.latitude,
      lon: _currentLocation.longitude,
      targetVibe: 'any',
    );
    if (mounted) {
      setState(() {
        _spots = spots;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('EXPLORE VIBES', style: TextStyle(letterSpacing: 4)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.climora',
              ),
              MarkerLayer(
                markers: _spots
                    .map(
                      (spot) => Marker(
                        point: LatLng(spot.latitude, spot.longitude),
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () => _showSpotDetails(spot),
                          child: Icon(
                            Icons.location_on,
                            color: _getVibeColor(spot.vibe),
                            size: 40,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),

          // Bottom Suggestions Carousel
          if (!_isLoading)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              height: 180,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.8),
                itemCount: _spots.length,
                itemBuilder: (context, index) {
                  final spot = _spots[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AppTheme.glassBox(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spot.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              spot.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(
                                    spot.vibe.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: _getVibeColor(
                                    spot.vibe,
                                  ).withValues(alpha: 0.3),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getVibeColor(
                                      spot.vibe,
                                    ).withValues(alpha: 0.3),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Go',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // Bottom Nav Bar
          const ClimoraBottomNav(currentRoute: '/navigation'),
        ],
      ),
    );
  }

  Color _getVibeColor(String vibe) {
    switch (vibe) {
      case 'calm':
        return Colors.tealAccent;
      case 'energetic':
        return Colors.orangeAccent;
      case 'focus':
        return Colors.blueAccent;
      default:
        return Colors.white;
    }
  }

  void _showSpotDetails(PlaceRecommendation spot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AppTheme.glassBox(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spot.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                spot.category,
                style: TextStyle(
                  color: _getVibeColor(spot.vibe),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(spot.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text('Start Navigation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
