import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF001A1A);
    const tealAccent = Color(0xFF002B2B);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [tealAccent, backgroundDark],
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top Header
                SliverToBoxAdapter(
                  child: _HeaderSection(primaryColor: primaryColor),
                ),

                // Search & Filter Section
                SliverToBoxAdapter(
                  child: _SearchSection(
                    primaryColor: primaryColor,
                    tealAccent: tealAccent,
                  ),
                ),

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
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Based on your local overcast conditions',
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'VIEW ALL',
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
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
                                _ExploreCard(
                                  imageUrl:
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAYUe8pbrohNZ5pSXqlwYxa3N8lEqwRp9ZJW2nIOSI_ZbmAUZNGpAYP1ZD5mbdceHd1mM0C1H13bLECTNpd9VJy129AtaMLVInb3xYj078q73v5HPKiSnXuIPG95AIuJ8XTE5282MvSqS-gmK2_p-MGR3Ll0pRXmM5ayOf7oqYjhAIjFy8uqkThUvyupv-u7vtu9wgPXfUDefeFhJySd1z9elyvRWAVyPYRmAWdmjWFVz4KPYLfsZwLEtMIOcF0tvA73APWmCGqZghm',
                                  title: 'The Rainy Sanctuary',
                                  location: 'Portland, OR',
                                  temp: '52°F',
                                  weather: 'RAINY',
                                  match: '98%',
                                  description:
                                      'A hidden gem perfect for focus, matched with deep lo-fi beats.',
                                  primaryColor: primaryColor,
                                  backgroundDark: backgroundDark,
                                ),
                                const SizedBox(height: 16),
                                _ExploreCard(
                                  imageUrl:
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDhQsl8_1oxHKDzSVRiQ6PxSkeX4VC_nkI-Mt_Z0XLjk2AqRGvhfBVS5bxFh8gi16H0R-M1WGRFpcBRA6GbNygXmhRyc6Kk3ENfIf45LSQbb4dVAXLpfhWNQ-1nRZDtpUqiomO4FMX6W2gR2PJZyFtllE2g4zfRAKJ4qyqYukiqcAj1mPbEt4t88O-I-vgJYsDusFmwxigF22QKhTEdpY_lldy0hKfgaBlRNmPNFeTtiF330FAK3C6Qs-0A5w8d8I9JISUUktKL24w_',
                                  title: 'Golden Peak',
                                  location: 'Aspen, CO',
                                  temp: '45°F',
                                  weather: 'SNOWY',
                                  match: '85%',
                                  description:
                                      'Crisp morning air paired with uplifting acoustic melodies.',
                                  primaryColor: primaryColor,
                                  backgroundDark: backgroundDark,
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
          _BottomNavBar(
            primaryColor: primaryColor,
            backgroundDark: backgroundDark,
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final Color primaryColor;
  const _HeaderSection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF002B2B).withValues(alpha: 0.6),
            border: Border(
              bottom: BorderSide(color: primaryColor.withValues(alpha: 0.1)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.hub_outlined, color: primaryColor, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    'Climora AI',
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor.withValues(alpha: 0.7),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Text(
                        'MOODY & RAINY',
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white30,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.2),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(Icons.account_circle, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  final Color primaryColor;
  final Color tealAccent;
  const _SearchSection({required this.primaryColor, required this.tealAccent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: tealAccent.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search destinations by vibe...',
                hintStyle: GoogleFonts.spaceGrotesk(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _MoodChip(
                  icon: Icons.water_drop,
                  label: 'Rainy Day',
                  isActive: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(width: 12),
                _MoodChip(
                  icon: Icons.coffee_outlined,
                  label: 'Cozy',
                  primaryColor: primaryColor,
                ),
                const SizedBox(width: 12),
                _MoodChip(
                  icon: Icons.terrain_outlined,
                  label: 'Adventurous',
                  primaryColor: primaryColor,
                ),
                const SizedBox(width: 12),
                _MoodChip(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Sunny Escape',
                  primaryColor: primaryColor,
                ),
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
  final Color primaryColor;

  const _MoodChip({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: isActive
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isActive ? Colors.black : Colors.grey),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.black : Colors.grey,
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
  final Color primaryColor;
  final Color backgroundDark;

  const _ExploreCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.temp,
    required this.weather,
    required this.match,
    required this.description,
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 420,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
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
                  colors: [backgroundDark, Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundDark.withValues(alpha: 0.8),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          match,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'MATCH',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: 1,
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
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF002B2B).withValues(alpha: 0.6),
                    ),
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
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      location,
                                      style: GoogleFonts.spaceGrotesk(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
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
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  weather.toUpperCase(),
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
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
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  const _BottomNavBar({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF002B2B).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  child: _NavButton(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    primaryColor: primaryColor,
                  ),
                ),
                _NavButton(
                  icon: Icons.explore,
                  label: 'Explore',
                  isActive: true,
                  primaryColor: primaryColor,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/map'),
                  child: _NavButton(
                    icon: Icons.map_outlined,
                    label: 'Map',
                    primaryColor: primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: _NavButton(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    primaryColor: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color primaryColor;

  const _NavButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? primaryColor : Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
