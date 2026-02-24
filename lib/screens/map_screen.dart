import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';
import '../presentation/widgets/map_pathway_painter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final MapController _mapController = MapController();

  // Default center at Tokyo (as per your design ref)
  final LatLng _center = const LatLng(35.6762, 139.6503);

  final List<Map<String, dynamic>> _recommendations = [
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCSF2KuYvzImdWDfIaQMJynmOVZF5sbVTztMKvVIKwpFyTj3AxoxBWOiVIVXLoUwNpRPYqD6inV-2Dss4F2vnek4SvjRpBLhrVGufYjbC_rb7KUrlUVYNI3H62Sqz_mmB6ZS7NFMU_kD-AVnv-DySkEnw4kjnU_C49myawVDJBpfFj9ZZ-SRYzU2mi0NrRV3u2P8U-Qiq1yWim3_zWGEZxTZGu2j8DO5H6TBKhTHDSaTKN6LHJIve0xX_ZCfk8BbEsXeboWlrqx5xgc',
      'title': 'The Blue Nook',
      'subtitle': 'Bookstore • 0.5mi',
      'tag': 'CALM',
      'lat': 35.6800,
      'lng': 139.6550,
    },
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA9oZU_n3TxzSX8FlOGGOyQ7W0vvrJToTWz5fN6HJLkzKxy8UgIYJlR9JB2i82KNpLJvoA1F9R1BmMVc7Bh0P6da70demoBnMF_gfm6MgGOgrZcF17NEqu2vWbVGZk1zmjNsBIq5ZSLsmcnIqha17LOzL69MnqhSD3ORyTr_97PEl0rOPEKc2HULCkrScvzz4NUu52tX-cIDY6X_LTCHFGcmrl3iF2wsfTqwZ6LyXfHRAFxulV2xtvk8ASziI7tVa8Qy7FzBqQgkMpp',
      'title': 'Misty Terrace',
      'subtitle': 'Cafe • 1.2mi',
      'tag': 'FOCUS',
      'lat': 35.6720,
      'lng': 139.6450,
    },
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDFkMrYGxNSb0I2dStWTPa49DhVvlRTvaOxLpmhVvkBJKXxp-noPizuNdC9N4aRWo8ce011AqMi5B-JdjIsbOZyPdp1J3_-SSgp3iAQGuRyiQmRqQ-4XbfvSIxywQnj3AAQkl7O5ICt3XXtZCIYGb34KrPfhyxuGHDvDDtnFSzbStsosvCumHYB-OQhKwrq_1-OSZ8QlA2LNckqU_R1sYmA2-BMvVAJg2iCJMLBxeTGFvOrJhyZpO8BbOqBvcu1qQyKElFCi-viB73w',
      'title': 'Zen Garden',
      'subtitle': 'Park • 2.1mi',
      'tag': 'CALM',
      'lat': 35.6850,
      'lng': 139.6400,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
                initialCenter: _center,
                initialZoom: 14.0,
                backgroundColor: backgroundDark,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                MarkerLayer(
                  markers: _recommendations.map((rec) {
                    return Marker(
                      point: LatLng(rec['lat'], rec['lng']),
                      width: 60,
                      height: 60,
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
                    );
                  }).toList(),
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
                    _mapController.move(_center, 14.0);
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
