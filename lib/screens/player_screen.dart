import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF041C1C);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [Color(0xFF083333), backgroundDark],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Navigation
                const _TopNavBar(primaryColor: primaryColor),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Album Art with Glow
                        const _AlbumArt(primaryColor: primaryColor),

                        const SizedBox(height: 40),

                        // Track Info
                        Text(
                          'Ethereal Echoes',
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Luminary Collective',
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Mood & Weather Tags
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _MoodTag(label: 'CALM', primaryColor: primaryColor),
                            SizedBox(width: 8),
                            _MoodTag(
                              label: 'RAINY',
                              primaryColor: primaryColor,
                            ),
                            SizedBox(width: 8),
                            _MoodTag(
                              label: 'NIGHT',
                              primaryColor: primaryColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Progress Section
                        const _ProgressSection(primaryColor: primaryColor),

                        const SizedBox(height: 40),

                        // Controls
                        const _PlaybackControls(
                          primaryColor: primaryColor,
                          backgroundDark: backgroundDark,
                        ),

                        const SizedBox(height: 40),

                        // AI Listening Modes
                        _AIModesSection(primaryColor: primaryColor),

                        const SizedBox(height: 120), // Bottom Nav Space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Glass Bottom Nav Bar
          const ClimoraBottomNav(
            currentRoute: '/player',
            primaryColor: primaryColor,
            backgroundDark: backgroundDark,
          ),
        ],
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  final Color primaryColor;
  const _TopNavBar({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavIcon(
            icon: Icons.chevron_left,
            onTap: () => Navigator.pop(context),
            primaryColor: primaryColor,
          ),
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDHB24PlcmzlfcVkbsbpEwQbYJPgNYvfmjoliaFxiiLoLq6Clqw8V_98XOzqd6SNTYmI1ygrEGwrpYUlodZRYiU3HRZV_24oLTYyMRFmhVs5KKnSghPqw1e-Yz8D-9WVFowI4WbvZZb9MSyNdi0dIuIHigbOg3kqzlVNIzYPGgOpI77nGeWEcOqAJSpCVrHjkBYV7ZP-q9JOFrVKvVDITzYKegrdRGSYZmTs26V-0VmvXdrFHB6t5-kzdhxUR2xz8zp8ldLrj08O9E_',
            height: 40,
            fit: BoxFit.contain,
          ),
          _NavIcon(
            icon: Icons.more_vert,
            onTap: () {},
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color primaryColor;

  const _NavIcon({
    required this.icon,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  final Color primaryColor;
  const _AlbumArt({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.2),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          // Art
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
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
        ],
      ),
    );
  }
}

class _MoodTag extends StatelessWidget {
  final String label;
  final Color primaryColor;
  const _MoodTag({required this.label, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final Color primaryColor;
  const _ProgressSection({required this.primaryColor});

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
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.6),
                      blurRadius: 15,
                    ),
                  ],
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
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ),
            Text(
              '3:45',
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
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
  final Color primaryColor;
  final Color backgroundDark;
  const _PlaybackControls({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
        ),
        const SizedBox(width: 32),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(Icons.play_arrow, color: backgroundDark, size: 48),
        ),
        const SizedBox(width: 32),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
        ),
      ],
    );
  }
}

class _AIModesSection extends StatelessWidget {
  final Color primaryColor;
  const _AIModesSection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _AIModeChip(
            icon: Icons.psychology,
            label: 'Focus Mode',
            primaryColor: primaryColor,
          ),
          const SizedBox(width: 12),
          _AIModeChip(
            icon: Icons.bedtime,
            label: 'Deep Sleep',
            primaryColor: primaryColor,
          ),
          const SizedBox(width: 12),
          _AIModeChip(
            icon: Icons.bolt,
            label: 'Energy Boost',
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }
}

class _AIModeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primaryColor;

  const _AIModeChip({
    required this.icon,
    required this.label,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
