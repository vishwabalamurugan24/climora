import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F1C1A);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top Header
                const SliverToBoxAdapter(child: _HeaderSection()),

                // Search & Filter Section
                const SliverToBoxAdapter(child: _SearchSection()),

                // Weather Matched Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weather-Matched for You',
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Based on your local overcast conditions',
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF5D7B75),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'VIEW ALL',
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFEFE6D5),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 1,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.85,
                          children: [
                            Column(
                              children: [
                                const _ExploreCard(
                                  imageUrl:
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAYUe8pbrohNZ5pSXqlwYxa3N8lEqwRp9ZJW2nIOSI_ZbmAUZNGpAYP1ZD5mbdceHd1mM0C1H13bLECTNpd9VJy129AtaMLVInb3xYj078q73v5HPKiSnXuIPG95AIuJ8XTE5282MvSqS-gmK2_p-MGR3Ll0pRXmM5ayOf7oqYjhAIjFy8uqkThUvyupv-u7vtu9wgPXfUDefeFhJySd1z9elyvRWAVyPYRmAWdmjWFVz4KPYLfsZwLEtMIOcF0tvA73APWmCGqZghm',
                                  title: 'The Rainy Sanctuary',
                                  location: 'Portland, OR',
                                  temp: '52°F',
                                  weather: 'RAINY',
                                  match: '98%',
                                  description:
                                      'A hidden gem perfect for focus, matched with deep lo-fi beats.',
                                ),
                                const SizedBox(height: 16),
                                const _ExploreCard(
                                  imageUrl:
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDhQsl8_1oxHKDzSVRiQ6PxSkeX4VC_nkI-Mt_Z0XLjk2AqRGvhfBVS5bxFh8gi16H0R-M1WGRFpcBRA6GbNygXmhRyc6Kk3ENfIf45LSQbb4dVAXLpfhWNQ-1nRZDtpUqiomO4FMX6W2gR2PJZyFtllE2g4zfRAKJ4qyqYukiqcAj1mPbEt4t88O-I-vgJYsDusFmwxigF22QKhTEdpY_lldy0hKfgaBlRNmPNFeTtiF330FAK3C6Qs-0A5w8d8I9JISUUktKL24w_',
                                  title: 'Golden Peak',
                                  location: 'Aspen, CO',
                                  temp: '45°F',
                                  weather: 'SNOWY',
                                  match: '85%',
                                  description:
                                      'Crisp morning air paired with uplifting acoustic melodies.',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
              ],
            ),
          ),

          // Glass Bottom Navigation Bar
          const ClimoraBottomNav(currentRoute: '/explore'),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: const Color(0xFF0F1C1A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.hub_rounded, color: Color(0xFFEFE6D5), size: 28),
              const SizedBox(width: 8),
              Text(
                'Climora',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CURRENT VIBE',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF63746C),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Text(
                    'MOODY & RAINY',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEFE6D5),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDHB24PlcmzlfcVkbsbpEwQbYJPgNYvfmjoliaFxiiLoLq6Clqw8V_98XOzqd6SNTYmI1ygrEGwrpYUlodZRYiU3HRZV_24oLTYyMRFmhVs5KKnSghPqw1e-Yz8D-9WVFowI4WbvZZb9MSyNdi0dIuIHigbOg3kqzlVNIzYPGgOpI77nGeWEcOqAJSpCVrHjkBYV7ZP-q9JOFrVKrVDITzYKegrdRGSYZmTs26V-0VmvXdrFHB6t5-kzdhxUR2xz8zp8ldLrj08O9E_',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF142925),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search destinations by vibe...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF5D7B75),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF5D7B75),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _MoodChip(
                  icon: Icons.water_drop_rounded,
                  label: 'Rainy Day',
                  isActive: true,
                ),
                SizedBox(width: 12),
                _MoodChip(icon: Icons.coffee_rounded, label: 'Cozy'),
                SizedBox(width: 12),
                _MoodChip(icon: Icons.terrain_rounded, label: 'Adventurous'),
                SizedBox(width: 12),
                _MoodChip(icon: Icons.wb_sunny_rounded, label: 'Sunny Escape'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _MoodChip({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEFE6D5) : const Color(0xFF142925),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive ? const Color(0xFF0F1C1A) : const Color(0xFFEFE6D5),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFF0F1C1A) : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String temp;
  final String weather;
  final String match;
  final String description;

  const _ExploreCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.temp,
    required this.weather,
    required this.match,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 400,
        decoration: const BoxDecoration(color: Color(0xFF142925)),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF0F1C1A).withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1C1A).withValues(alpha: 0.6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          match,
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEFE6D5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'MATCH',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: Color(0xFF5D7B75),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  location,
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF5D7B75),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              temp,
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              weather.toUpperCase(),
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5D7B75),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5D7B75),
                          height: 1.5,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
