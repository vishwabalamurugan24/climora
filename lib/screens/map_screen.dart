import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/climora_bottom_nav.dart';
import '../presentation/widgets/map_pathway_painter.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();

  LatLng _currentPosition = const LatLng(35.6762, 139.6503); // Default Tokyo
  bool _isLocationLoaded = false;
  List<Map<String, dynamic>> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      final spots = await _locationService.getNearbyMoodSpots(
        lat: position.latitude,
        lon: position.longitude,
        targetVibe: 'any',
      );

      if (mounted) {
        setState(() {
          _currentPosition = latLng;
          _isLocationLoaded = true;
          _recommendations = spots
              .map(
                (s) => {
                  'imageUrl':
                      'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&q=80&w=300',
                  'title': s.name,
                  'subtitle': '${s.category} • New Space',
                  'tag': s.vibe.toUpperCase(),
                  'lat': s.latitude,
                  'lng': s.longitude,
                },
              )
              .toList();
        });
        _mapController.move(latLng, 14.0);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF1D1B15);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Live FlutterMap with Dark Tiles
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 14.0,
                backgroundColor: backgroundDark,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                if (_isLocationLoaded)
                  MarkerLayer(
                    markers: [
                      // User Location Marker
                      Marker(
                        point: _currentPosition,
                        width: 80,
                        height: 80,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: MapPathwayPainter(
                                pulseValue: _pulseController.value,
                              ),
                            );
                          },
                        ),
                      ),
                      // Recommendation Markers
                      ..._recommendations.map((rec) {
                        return Marker(
                          point: LatLng(rec['lat'], rec['lng']),
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
              ],
            ),
          ),

          // UI Overlay
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cyclone,
                              color: backgroundDark,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Climora AI',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _GlassIconButton(
                        icon: Icons.search,
                        onTap: () {},
                        primaryColor: primaryColor,
                      ),
                    ],
                  ),
                ),

                // Season Status Panel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _GlassPanel(
                    primaryColor: primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CURRENT SEASON',
                              style: GoogleFonts.spaceGrotesk(
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Summer Season',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'LOCAL CLIMATE',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white38,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'High Humidity • 82°F',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Recommendations Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mood-Matched Recommendations',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'View All',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _recommendations.length,
                          itemBuilder: (context, index) {
                            final rec = _recommendations[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  _mapController.move(
                                    LatLng(rec['lat'], rec['lng']),
                                    16.0,
                                  );
                                },
                                child: _RecCard(
                                  imageUrl: rec['imageUrl'],
                                  title: rec['title'],
                                  subtitle: rec['subtitle'],
                                  tag: rec['tag'],
                                  primaryColor: primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating Bottom Nav
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  child: ClimoraBottomNav(currentRoute: '/map'),
                ),
              ],
            ),
          ),

          // Map Controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              children: [
                _GlassIconButton(
                  icon: Icons.add,
                  onTap: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  },
                  primaryColor: primaryColor,
                  isSquare: true,
                ),
                const SizedBox(height: 8),
                _GlassIconButton(
                  icon: Icons.remove,
                  onTap: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  },
                  primaryColor: primaryColor,
                  isSquare: true,
                ),
                const SizedBox(height: 16),
                _GlassIconButton(
                  icon: Icons.near_me,
                  onTap: () {
                    _mapController.move(_currentPosition, 14.0);
                  },
                  primaryColor: primaryColor,
                  isSquare: true,
                  iconColor: primaryColor,
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 24,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color primaryColor;
  final bool isSquare;
  final Color? iconColor;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.primaryColor,
    this.isSquare = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isSquare ? 12 : 25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B15).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(isSquare ? 12 : 25),
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Center(
              child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final Color primaryColor;

  const _GlassPanel({required this.child, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1B15).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RecCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String tag;
  final Color primaryColor;

  const _RecCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B15).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
