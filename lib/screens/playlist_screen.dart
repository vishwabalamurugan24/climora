import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFC2B180);
    final backgroundDark = const Color(0xFF0A1A1A);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Header Image & Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 288,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuD9wYHzXkQdstIX3y3jWAZfhMmRu2jFJ7a32VzUQybxDNXDFK6hPZ-FooqZwLli8QSGirf1zcPogf0U7GB5Ef271uipubddT8z9Kn7sFTnqlpjjY9jYJUH5jmDCELr5-PSqkB1XGxndocnUVEI1bqZt_nQPu2vYXJKsMXWYX9tMHpkNkW9D_cBkn42aueMhz51U3xaGnSRuKGPahlbZmL5IcApS15HBfCCFN8kkW2PstLlE_G-ivtnU2YBwq4haB5ud47ADXH-Qw2A5',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, backgroundDark],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top Navigation
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircularIconButton(
                          icon: Icons.chevron_left,
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/home'),
                        ),
                        _CircularIconButton(
                          icon: Icons.more_vert,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _SearchBar(primaryColor: primaryColor),
                  ),
                ),

                const SizedBox(height: 16).toSliver(),

                // Category Tabs
                SliverToBoxAdapter(
                  child: _CategoryTabs(primaryColor: primaryColor),
                ),

                const SizedBox(height: 24).toSliver(),

                // Playlist Info Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _PlaylistInfoCard(
                      primaryColor: primaryColor,
                      backgroundDark: backgroundDark,
                    ),
                  ),
                ),

                const SizedBox(height: 32).toSliver(),

                // Track List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _TrackItem(
                        title: 'Nebula Drift',
                        artist: 'Lofi Chill • Active Now',
                        duration: '3:45',
                        isActive: true,
                        primaryColor: primaryColor,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBzhTqijFZK55fiphrGEZuNzCLzuuSboxh-ee2ulxR3nCe-3mCiMmf002DepxPc6DGISAl_wpGZAM_Dv2IXG4bi35NYUisGDd52yzNzwSa73LYenF8H3HB7Vi_xofQ7Wt8K9T4p3 نزد 09369999499',
                      ),
                      _TrackItem(
                        title: 'Static Rain',
                        artist: 'Ether Echo',
                        duration: '4:12',
                        primaryColor: primaryColor,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBgxGcMkQRVz7wy-ZItnp8Vm84aSBIlw70cYgdddlyI2Sze-Mr18ueIArbWYnowylMLLMDpAiCE_08NkMYGbYcJbnaXP8hdnxrbSEvlr_YpL4FQJGvA01ptYafiJx1K2pspr_Cl_VqCE0DPi7Fb15wD9H5AYRhU-plTze4nBsTi9jm5p3YZ_fBLy5eMsj3sx4fMd8aTXbWeUBYUVmudRxfPYMDxWkRfAq6iF5uEC4JnrolkGo-mwy26eUu0iG7gE906-K_VYF5UUGP-',
                      ),
                      _TrackItem(
                        title: 'Mist Patterns',
                        artist: 'Vapor Trails',
                        duration: '2:58',
                        primaryColor: primaryColor,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhTuhbd9k6bFFN_Y5cv7EGBg5wYycX0S5MxIvHmgdMBRPTbFX85h16duMzWfpQfVWkrUQJLTgZ-7fmJq60AHzbwSBJLyeRgIeB-nRSRhC9z4eOkxbuCexM6aLyr0HsbrrYVrXvBx62hF9q7uMjeFXr356-7WcSNPopwkUzJ0Mfzln3R-hjBR9BQAcHJOSy5R0qdsP7jMxSEOADxhBBGmNxysm4d_yPuPDvh-9AlmsWdLdYUCdXQn2iWXSZ1BbYBWDKhipy7T2I0LVU',
                      ),
                      _TrackItem(
                        title: 'Dewpoint Focus',
                        artist: 'Atmosphere',
                        duration: '5:20',
                        primaryColor: primaryColor,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCdXRl_Ecnn--5-5QK4pW9sHUgxyfnh1R3Pa4K0jVgToMwYVAemiwKv6FTG60Mhg5rF8Oirm_FnnokTs4ZLg5nv48cZ2kSKi4GhWfEioE4AXIuWgdHv4-IRobR8Ft-5oX481NNRbQU81kpSUBf8ENyT8ZnTG9_pFZY4hsg-nW9ST8xjKx3FMacyZh7TsMfRPm9OrnvWPIONpKLBx9UrPGQClpkLpNkKXDz_H-Y1xi1qb5vfIsDaBO9eCnGv5T3Z5ULXNIWdzucbl1ye',
                      ),
                    ]),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
              ],
            ),
          ),

          // Bottom Bar
          const ClimoraBottomNav(currentRoute: '/playlist'),
        ],
      ),
    );
  }
}

extension WidgetToSliver on Widget {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircularIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final Color primaryColor;
  const _SearchBar({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for a song...',
                    hintStyle: GoogleFonts.spaceGrotesk(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final Color primaryColor;
  const _CategoryTabs({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final categories = ['Ambient', 'Lofi', 'Calm', 'Melancholic'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: categories.map((cat) {
          final isFirst = cat == categories.first;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isFirst
                    ? primaryColor
                    : Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20),
                border: isFirst
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isFirst ? Colors.black : Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PlaylistInfoCard extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  const _PlaylistInfoCard({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD9wYHzXkQdstIX3y3jWAZfhMmRu2jFJ7a32VzUQybxDNXDFK6hPZ-FooqZwLli8QSGirf1zcPogf0U7GB5Ef271uipubddT8z9Kn7sFTnqlpjjY9jYJUH5jmDCELr5-PSqkB1XGxndocnUVEI1bqZt_nQPu2vYXJKsMXWYX9tMHpkNkW9D_cBkn42aueMhz51U3xaGnSRuKGPahlbZmL5IcApS15HBfCCFN8kkW2PstLlE_G-ivtnU2YBwq4haB5ud47ADXH-Qw2A5',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: backgroundDark,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Rainy Day Sanctuary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Generated by Climora • 24 Tracks',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Text(
                'A curated collection for deep focus and calm during low-pressure weather conditions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Tag(icon: Icons.water_drop, label: 'RAINY', isActive: true),
                  SizedBox(width: 8),
                  _Tag(icon: Icons.mode_night, label: 'CALM'),
                  SizedBox(width: 8),
                  _Tag(icon: Icons.air, label: 'LOW PRESSURE'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _Tag({required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFC2B180);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? primaryColor.withValues(alpha: 0.4)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: isActive ? primaryColor : Colors.grey),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackItem extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;
  final String imageUrl;
  final bool isActive;
  final Color primaryColor;

  const _TrackItem({
    required this.title,
    required this.artist,
    required this.duration,
    required this.imageUrl,
    this.isActive = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? primaryColor.withValues(alpha: 0.3)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 48,
              width: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isActive ? primaryColor : Colors.white,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isActive) Icon(Icons.equalizer, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            duration,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
