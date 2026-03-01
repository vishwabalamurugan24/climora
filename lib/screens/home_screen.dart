
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../widgets/climora_bottom_nav.dart';
import 'desktop_home_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isListening = false;
  double _voiceVolume = 0.0;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF0A1F1F);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1100) {
          return DesktopHomeView(
            primaryColor: primaryColor,
            backgroundDark: backgroundDark,
          );
        }
        return _MobileHomeView(
          isListening: _isListening,
          voiceVolume: _voiceVolume,
          onVoiceToggle: () {
            setState(() => _isListening = !_isListening);
            if (_isListening) _simulateVoice();
          },
        );
      },
    );
  }

  void _simulateVoice() async {
    while (_isListening) {
      if (!mounted) break;
      setState(() => _voiceVolume = math.Random().nextDouble());
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) {
      setState(() => _voiceVolume = 0.0);
    }
  }
}

class _MobileHomeView extends StatelessWidget {
  final bool isListening;
  final double voiceVolume;
  final VoidCallback onVoiceToggle;

  const _MobileHomeView({
    required this.isListening,
    required this.voiceVolume,
    required this.onVoiceToggle,
  });

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F1C1A);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const _HeaderSection(),
                    const SizedBox(height: 24),
                    const _WeatherCard(),
                    const SizedBox(height: 32),
                    const _DetectedMoodSection(),
                    const SizedBox(height: 32),
                    const _QuickActionsSection(),
                  ],
                ),
              ),
            ),
          ),
          const ClimoraBottomNav(currentRoute: '/home'),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, User',
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
            Text(
              'Ready for your wellness journey?',
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
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDHB24PlcmzlfcVkbsbpEwQbYJPgNYvfmjoliaFxiiLoLq6Clqw8V_98XOzqd6SNTYmI1ygrEGwrpYUlodZRYiU3HRZV_24oLTYyMRFmhVs5KKnSghPqw1e-Yz8D-9WVFowI4WbvZZb9MSyNdi0dIuIHigbOg3kqzlVNIzYPGgOpI77nGeWEcOqAJSpCVrHjkBYV7ZP-q9JOFrVKrVDITzYKegrdRGSYZmTs26V-0VmvXdrFHB6t5-kzdhxUR2xz8zp8ldLrj08O9E_',
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    const creamBg = Color(0xFFEFE6D5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: creamBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WEATHER',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF63746C),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '24°C',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2F2B),
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sunny with a light breeze',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5C55),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9F2E6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: Color(0xFF233B36),
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectedMoodSection extends StatelessWidget {
  const _DetectedMoodSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detected Mood',
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF142925),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          color: Color(0xFF2C4F48),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Calm State',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your biometrics suggest you are relaxed and centered right now.',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF728A84),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C3833),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Color(0xFFD6E2DF),
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.25,
          children: [
            _ActionCard(
              icon: Icons.mic_rounded,
              label: 'Voice AI',
              onTap: () {},
            ),
            _ActionCard(
              icon: Icons.music_note_rounded,
              label: 'Play Music',
              onTap: () => Navigator.pushNamed(context, '/playlist'),
            ),
            _ActionCard(
              icon: Icons.map_rounded,
              label: 'Find Places',
              onTap: () => Navigator.pushNamed(context, '/map'),
            ),
            _ActionCard(
              icon: Icons.refresh_rounded,
              label: 'Refresh Mode',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1D2432), // Dark bluish grey from screenshot
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.03), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF6B8A91), // Subtle blue-teal tint
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
