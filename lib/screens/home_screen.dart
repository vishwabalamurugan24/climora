import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../widgets/climora_bottom_nav.dart';
import '../presentation/widgets/voice_orb.dart';
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
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF0A1F1F);
    const bgGradientStart = Color(0xFF134E4E);

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
                colors: [bgGradientStart, backgroundDark],
                stops: [0.0, 0.6],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section: Greeting & Weather Dashboard
                  const _HeaderSection(primaryColor: primaryColor),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/weather'),
                      child: const _WeatherDashboard(
                        primaryColor: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Mood Symphony Section
                  _MoodSymphonySection(primaryColor: primaryColor),

                  const SizedBox(height: 40),

                  // Central Voice Activation Orb
                  GestureDetector(
                    onTap: onVoiceToggle,
                    child: VoiceOrb(
                      isListening: isListening,
                      volume: voiceVolume,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      isListening
                          ? "Listening to your vibe..."
                          : "What's your vibe today?",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white60,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Climate Recommendations Section
                  _ClimateRecommendationsSection(
                    primaryColor: primaryColor,
                    backgroundDark: backgroundDark,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Nav Bar
          ClimoraBottomNav(
            currentRoute: '/home',
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening, Alex',
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: primaryColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Seattle, WA',
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor.withValues(alpha: 0.8),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
                image: const DecorationImage(
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
    );
  }
}

class _WeatherDashboard extends StatelessWidget {
  final Color primaryColor;
  const _WeatherDashboard({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.cloudy_snowing, size: 40, color: primaryColor),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '58°F',
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'MIST & RAIN',
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 1,
                color: primaryColor.withValues(alpha: 0.2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'AI Sync: Active',
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    'ATMOSPHERIC MOOD SHIFT',
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: const TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
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

class _MoodSymphonySection extends StatelessWidget {
  final Color primaryColor;
  const _MoodSymphonySection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood Symphony',
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'CUSTOMIZE',
                style: GoogleFonts.spaceGrotesk(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/playlist'),
                child: _MoodCard(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Happy',
                  subtitle: 'UPLIFTING BEATS',
                  primaryColor: primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/playlist'),
                child: _MoodCard(
                  icon: Icons.filter_drama_outlined,
                  title: 'Calm',
                  subtitle: 'AMBIENT ECHOES',
                  primaryColor: primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/playlist'),
                child: _MoodCard(
                  icon: Icons.water_drop_outlined,
                  title: 'Sad',
                  subtitle: 'MELODIC RAIN',
                  primaryColor: primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/playlist'),
                child: _MoodCard(
                  icon: Icons.grain,
                  title: 'Focus',
                  subtitle: 'LO-FI TEXTURES',
                  primaryColor: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;

  const _MoodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            border: Border(
              top: BorderSide(color: primaryColor.withValues(alpha: 0.2)),
              left: BorderSide(color: primaryColor.withValues(alpha: 0.05)),
              right: BorderSide(color: primaryColor.withValues(alpha: 0.05)),
              bottom: BorderSide(color: primaryColor.withValues(alpha: 0.05)),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: primaryColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    subtitle.toUpperCase(),
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
        ),
      ),
    );
  }
}

class _ClimateRecommendationsSection extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  const _ClimateRecommendationsSection({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Climate Recommendations',
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/player'),
                child: _RecommendationCard(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAYUe8pbrohNZ5pSXqlwYxa3N8lEqwRp9ZJW2nIOSI_ZbmAUZNGpAYP1ZD5mbdceHd1mM0C1H13bLECTNpd9VJy129AtaMLVInb3xYj078q73v5HPKiSnXuIPG95AIuJ8XTE5282MvSqS-gmK2_p-MGR3Ll0pRXmM5ayOf7oqYjhAIjFy8uqkThUvyupv-u7vtu9wgPXfUDefeFhJySd1z9elyvRWAVyPYRmAWdmjWFVz4KPYLfsZwLEtMIOcF0tvA73APWmCGqZghm',
                  title: 'Rainy Evening',
                  description:
                      'Deep melancholic piano and atmospheric rain sounds.',
                  weatherTag: 'Matched to current weather',
                  weatherIcon: Icons.cloudy_snowing,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/player'),
                child: _RecommendationCard(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDhQsl8_1oxHKDzSVRiQ6PxSkeX4VC_nkI-Mt_Z0XLjk2AqRGvhfBVS5bxFh8gi16H0R-M1WGRFpcBRA6GbNygJmhRyc6Kk3ENfIf45LSQbb4dVAXLpfhWNQ-1nRZDtpUqiomO4FMX6W2gR2PJZyFtllE2g4zfRAKJ4qyqYukiqcAj1mPbEt4t88O-I-vgJYsDusFmwxigF22QKhTEdpY_lldy0hKfgaBlRNmPNFeTtiF330FAK3C6Qs-0A5w8d8I9JISUUktKL24w_',
                  title: 'Sunny Morning Energy',
                  description:
                      'Bright rhythmic acoustic and upbeat indie folk.',
                  weatherTag: 'Forecast: Morning Energy',
                  weatherIcon: Icons.sunny,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/player'),
                child: _RecommendationCard(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDdbIKktNjwklIrVdg_yZvPiVQqLrsdRl4CgMslLhwuPR_Y6s8DMyI_Pzoh_Sj4O6YkFVMj9UGBBSh-Xb2VfTfHBievFVa49RWk7_m5iM0Tn61tMS4EwXO7-sWLQPmcyDLrkpsxuLsiFjuPDjiHlnD1A9TEFeERSAWUuEwlq13b3VTXMr64YIWxWmifYH2cQcFHJTCxKLyu8syRlwo7hWq5ikQYAbRSzvJqno-mk148SCUW3El-0mz6LesGykPNHGEeQ7pUajPUVmAp',
                  title: 'Arctic Chill',
                  description: 'Crystalline synth pads and minimal techno.',
                  weatherTag: 'Cooling Selection',
                  weatherIcon: Icons.ac_unit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String weatherTag;
  final IconData weatherIcon;

  const _RecommendationCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.weatherTag,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF0A1F1F);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 128,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        backgroundDark.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: [
                    Icon(weatherIcon, size: 14, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      weatherTag.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
