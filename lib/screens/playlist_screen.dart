
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);
    const Color bgDark = Color(0xFF0F1C1A);

    return Scaffold(
      backgroundColor: bgDark,
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
                        colors: [Colors.transparent, bgDark],
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
                          icon: Icons.chevron_left_rounded,
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/home'),
                        ),
                        _CircularIconButton(
                          icon: Icons.more_horiz_rounded,
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
                    child: _SearchBar(primaryColor: primaryCream),
                  ),
                ),

                const SizedBox(height: 16).toSliver(),

                // Category Tabs
                SliverToBoxAdapter(
                  child: _CategoryTabs(primaryColor: primaryCream),
                ),

                const SizedBox(height: 24).toSliver(),

                // Playlist Info Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _PlaylistInfoCard(
                      primaryColor: primaryCream,
                      backgroundDark: bgDark,
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
                        primaryColor: primaryCream,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBzhTqijFZK55fiphrGEZuNzCLzuuSboxh-ee2ulxR3nCe-3mCiMmf002DepxPc6DGISAl_wpGZAM_Dv2IXG4bi35NYUisGDd52yzNzwSa73LYenF8H3HB7Vi_xofQ7Wt8K9T4p3 نزد 09369999499',
                      ),
                      _TrackItem(
                        title: 'Static Rain',
                        artist: 'Ether Echo',
                        duration: '4:12',
                        primaryColor: primaryCream,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBgxGcMkQRVz7wy-ZItnp8Vm84aSBIlw70cYgdddlyI2Sze-Mr18ueIArbWYnowylMLLMDpAiCE_08NkMYGbYcJbnaXP8hdnxrbSEvlr_YpL4FQJGvA01ptYafiJx1K2pspr_Cl_VqCE0DPi7Fb15wD9H5AYRhU-plTze4nBsTi9jm5p3YZ_fBLy5eMsj3sx4fMd8aTXbWeUBYUVmudRxfPYMDxWkRfAq6iF5uEC4JnrolkGo-mwy26eUu0iG7gE906-K_VYF5UUGP-',
                      ),
                      _TrackItem(
                        title: 'Mist Patterns',
                        artist: 'Vapor Trails',
                        duration: '2:58',
                        primaryColor: primaryCream,
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhTuhbd9k6bFFN_Y5cv7EGBg5wYycX0S5MxIvHmgdMBRPTbFX85h16duMzWfpQfVWkrUQJLTgZ-7fmJq60AHzbwSBJLyeRgIeB-nRSRhC9z4eOkxbuCexM6aLyr0HsbrrYVrXvBx62hF9q7uMjeFXr356-7WcSNPopwkUzJ0Mfzln3R-hjBR9BQAcHJOSy5R0qdsP7jMxSEOADxhBBGmNxysm4d_yPuPDvh-9AlmsWdLdYUCdXQn2iWXSZ1BbYBWDKhipy7T2I0LVU',
                      ),
                      _TrackItem(
                        title: 'Dewpoint Focus',
                        artist: 'Atmosphere',
                        duration: '5:20',
                        primaryColor: primaryCream,
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final Color primaryColor;
  const _SearchBar({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a song...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF5D7B75),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: primaryColor,
            ),
          ),
        ],
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isFirst ? primaryColor : const Color(0xFF142925),
                borderRadius: BorderRadius.circular(20),
                border: isFirst
                    ? null
                    : Border.all(color: primaryColor.withValues(alpha: 0.1)),
              ),
              child: Text(
                cat,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isFirst ? const Color(0xFF0F1C1A) : Colors.white,
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
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
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: backgroundDark,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Rainy Day Sanctuary',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Generated by Climora • 24 Tracks',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5D7B75),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'A curated collection for deep focus and calm during low-pressure weather conditions.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Tag(
                icon: Icons.water_drop_rounded,
                label: 'RAINY',
                isActive: true,
              ),
              SizedBox(width: 8),
              _Tag(icon: Icons.mode_night_rounded, label: 'CALM'),
              SizedBox(width: 8),
              _Tag(icon: Icons.air_rounded, label: 'LOW PRESSURE'),
            ],
          ),
        ],
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
    const Color primaryColor = Color(0xFFEFE6D5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? primaryColor.withValues(alpha: 0.3)
              : primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: isActive ? primaryColor : const Color(0xFF5D7B75),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: isActive ? primaryColor : const Color(0xFF5D7B75),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withValues(alpha: 0.05)
            : const Color(0xFF142925),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? primaryColor.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 56,
              width: 56,
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
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isActive ? primaryColor : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artist,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isActive
                        ? primaryColor.withValues(alpha: 0.8)
                        : const Color(0xFF5D7B75),
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bar_chart_rounded,
                color: primaryColor,
                size: 20,
              ),
            )
          else
            Text(
              duration,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5D7B75),
              ),
            ),
        ],
      ),
    );
  }
}
