import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/desktop_sidebar.dart';
import '../widgets/desktop_now_playing_panel.dart';

class DesktopHomeView extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;

  const DesktopHomeView({
    super.key,
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Row(
        children: [
          // Sidebar
          DesktopSidebar(primaryColor: primaryColor, currentRoute: '/home'),

          // Main Center Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: "Mood Symphony"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mood Symphony',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/weather'),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.device_thermostat_rounded,
                                  color: Color(0xFFC2B180),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'CURRENTLY 22°C',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                const Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Color(0xFFC2B180),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'CLEAR SKIES • LONDON',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _ActionBtn(icon: Icons.refresh_rounded),
                          const SizedBox(width: 12),
                          _FilterBtn(),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 64),

                  // Atmosphere Selection
                  Text(
                    'SELECT YOUR ATMOSPHERE',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white24,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/playlist'),
                          child: const _MoodCard(
                            icon: Icons.sentiment_satisfied_rounded,
                            label: 'Happy',
                            sub: 'Uplifting & Energetic',
                            glow: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/playlist'),
                          child: const _MoodCard(
                            icon: Icons.air_rounded,
                            label: 'Calm',
                            sub: 'Deep Relaxation',
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/playlist'),
                          child: const _MoodCard(
                            icon: Icons.water_drop_rounded,
                            label: 'Melancholy',
                            sub: 'Rainy Day Echoes',
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/playlist'),
                          child: const _MoodCard(
                            icon: Icons.center_focus_strong_rounded,
                            label: 'Focus',
                            sub: 'Precision Binaural',
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // Climate Matched
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CLIMATE-MATCHED FOR YOU',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white24,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white24,
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white24,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/player'),
                          child: const _RecCard(
                            title: 'Petrichor Lo-Fi',
                            sub: 'Sync with Stormy Skies',
                            tag: 'RAIN SYNC',
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/player'),
                          child: const _RecCard(
                            title: 'Golden Hour Jazz',
                            sub: 'Sync with Warm Sunset',
                            tag: 'SUN SYNC',
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/player'),
                          child: const _RecCard(
                            title: 'Midnight Electronic',
                            sub: 'Sync with Clear Night',
                            tag: 'NIGHT SYNC',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Right Panel
          DesktopNowPlayingPanel(
            primaryColor: primaryColor,
            backgroundDark: backgroundDark,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  const _ActionBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }
}

class _FilterBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_list_rounded,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Filters',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool glow;
  final Color? color;

  const _MoodCard({
    required this.icon,
    required this.label,
    required this.sub,
    this.glow = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? const Color(0xFFC2B180);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: glow
              ? [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: -10,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: themeColor, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecCard extends StatelessWidget {
  final String title;
  final String sub;
  final String tag;

  const _RecCard({required this.title, required this.sub, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&q=80&w=1000',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFFC2B180),
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.white60,
                    size: 48,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          sub,
          style: GoogleFonts.spaceGrotesk(color: Colors.white38, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
