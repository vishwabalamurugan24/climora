import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F1C1A);
    const primaryCream = Color(0xFFEFE6D5);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  // Top Navigation
                  const _TopNavBar(),

                  const SizedBox(height: 20),
                  // Album Art with Glow
                  const _AlbumArt(),

                  const SizedBox(height: 40),

                  // Track Info
                  Text(
                    'Ethereal Echoes',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Luminary Collective',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D7B75),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Mood & Weather Tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _MoodTag(label: 'CALM'),
                      const SizedBox(width: 8),
                      const _MoodTag(label: 'RAINY'),
                      const SizedBox(width: 8),
                      const _MoodTag(label: 'NIGHT'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Progress Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _ProgressSection(),
                  ),

                  const SizedBox(height: 40),

                  // Controls
                  const _PlaybackControls(primaryCream: primaryCream),

                  const SizedBox(height: 40),

                  // AI Listening Modes
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _AIModesSection(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Nav Bar
          const ClimoraBottomNav(currentRoute: '/player'),
        ],
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavIcon(
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          Text(
            'NOW PLAYING',
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF63746C),
                letterSpacing: 2,
              ),
            ),
          ),
          _NavIcon(icon: Icons.more_horiz_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  const _AlbumArt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
          image: const DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA6AYqroBUqjJ7d9UlnUY6_SrwUzODtffOHhinMaGCBB3PM8BmbZB2QxJdVOytVi6rKErriPPJoE8E-biL2XOUi7JzZGJczhAmuc45WMWZdzzJE0NxGU_wxRj2dwIo6t4nrXkhXDcJyC3zE0t8vZhMh8zxeQQVip-5BamgBKZqUmqwHGmCENfEZE9Qm6WRsGsekghlDoygbQKBMXTMv2OnxbDz5Hmsn3bLovh-WX_6wICbjtpkHrstrCsDHGKUC1CAc3oXNYzbxdJk2',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _MoodTag extends StatelessWidget {
  final String label;

  const _MoodTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF63746C),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.35,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE6D5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1:17',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF63746C),
                ),
              ),
            ),
            Text(
              '-2:28',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF63746C),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  final Color primaryCream;
  const _PlaybackControls({required this.primaryCream});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(width: 32),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: primaryCream,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryCream.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.pause_rounded,
            color: Color(0xFF0F1C1A),
            size: 40,
          ),
        ),
        const SizedBox(width: 32),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }
}

class _AIModesSection extends StatelessWidget {
  const _AIModesSection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _AIModeChip(icon: Icons.psychology_rounded, label: 'Focus Mode'),
          SizedBox(width: 12),
          _AIModeChip(icon: Icons.bedtime_rounded, label: 'Deep Sleep'),
          SizedBox(width: 12),
          _AIModeChip(icon: Icons.bolt_rounded, label: 'Energy Boost'),
        ],
      ),
    );
  }
}

class _AIModeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AIModeChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFEFE6D5), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
