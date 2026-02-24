import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/climora_bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF1D1B15);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Full Screen Map Background
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAAQSk4YQBvHSNMEjVckjMuHSVnE78eAX3Wi8av3kNbOrCaApNcx51zQ6CRLBaiOjU3ukmAQrglvesvZwJgbtD9nzV2SakZHk2t9jViyg5KwKDxFgEWhggbj59yGpFecITtiGsOipcU4zu5GSylDtXk4aOlVArKLgsiAw2OjIYim_xOEXGRYkzymiOrUWiyx20WTX9jGGwRfr71mYNMntnHz9KIhfXTc1pOpyi2I_DetzTe_8zN3cJjdKVZs5K1Nes8w43c4xs3067y',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Header Panel
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _ClimateStatusPanel(
                    primaryColor: primaryColor,
                    backgroundDark: backgroundDark,
                  ),
                ),

                // Search Bar Overlay
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SearchBarOverlay(primaryColor: primaryColor),
                ),

                const Spacer(),

                // Smart Recommendations Carousel
                const _SmartRecommendationsCarousel(
                  primaryColor: primaryColor,
                  backgroundDark: backgroundDark,
                ),

                // Bottom Navigation Bar
                const ClimoraBottomNav(currentRoute: '/map'),
              ],
            ),
          ),

          // Map Navigation Controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: _MapControls(
              primaryColor: primaryColor,
              backgroundDark: backgroundDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClimateStatusPanel extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  const _ClimateStatusPanel({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundDark.withValues(alpha: 0.7),
            border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: primaryColor),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/home'),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.cloudy_snowing,
                          color: primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CLIMATE STATUS',
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: primaryColor.withValues(alpha: 0.8),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Text(
                            'Rainy Period',
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: backgroundDark,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              const SizedBox(height: 8),
              Text(
                '"The rhythmic rain suggests a cozy, indoor setting. Perfect for introspection and deep work."',
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBarOverlay extends StatelessWidget {
  final Color primaryColor;
  const _SearchBarOverlay({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1B15).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find climate-perfect spots...',
                    hintStyle: GoogleFonts.spaceGrotesk(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              Icon(Icons.mic, color: primaryColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapControls extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  const _MapControls({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ControlBtn(
          icon: Icons.add,
          primaryColor: primaryColor,
          backgroundDark: backgroundDark,
        ),
        const SizedBox(height: 8),
        _ControlBtn(
          icon: Icons.remove,
          primaryColor: primaryColor,
          backgroundDark: backgroundDark,
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Icon(Icons.near_me, color: backgroundDark, size: 20),
        ),
      ],
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final Color primaryColor;
  final Color backgroundDark;
  const _ControlBtn({
    required this.icon,
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: backgroundDark.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _SmartRecommendationsCarousel extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  const _SmartRecommendationsCarousel({
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Smart Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'VIEW ALL',
                style: GoogleFonts.spaceGrotesk(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _RecCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAu1ylkm2LYmY4pwDENBNMo76ta8VmijXCDerW8gYvoN4cUlbxiEUrptfuQf97VoxAOsjOy5M6zTMZG_ShNczK1GV-tONBM-zRnjZHJaflgKSLnv5M0KPV36WbC5Uto-uED89yJmu6FI_QQY_FAfRSHK2HofxN7VenOjLIEatXgQUHbAIVLw4Ot6ElR-JtefLShHQTj_xugjCoQZKCqMUU3F6rF9mDEtm5kVNLbLTZzNPaWjGbGqsmgnN-L37MmxyOfJaslalFjl7Vs',
                title: 'The Quiet Nook',
                subtitle: 'Artisanal Bookstore & Cafe',
                dist: '0.4 MI',
                tags: const ['MOOD: CALM', 'RAIN-SAFE'],
                primaryColor: primaryColor,
                backgroundDark: backgroundDark,
              ),
              const SizedBox(width: 12),
              _RecCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDfByPLaCmSJ6D0BtQeHVh2sgXqptCm5aEIcreQINvze8N8GIH_igtUCyxvk6KvtZlaWL9xFknlw0lGn5Di3nOikfm_yfyk8-xO00aIbbaL4QC_dMC1KGtYNxO6wSOjsXu5OVCFMRDKe1xNN1az5F_Fw5HKlPB6K-C8LBaRxIKAejtlI39SODsdczNrpQyYI5p_v2bHrBxMeGUq5_ot5UB51sfHM8JyWa2wiBmp_ogWQPgr_P5LPQOB11ur7mxyrDpNS8d-nr6tbtCB',
                title: 'Mist & Leaf Tea',
                subtitle: 'Herbal Infusions & Zen Space',
                dist: '0.8 MI',
                tags: const ['MOOD: FOCUS', 'WARMTH'],
                primaryColor: primaryColor,
                backgroundDark: backgroundDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String dist;
  final List<String> tags;
  final Color primaryColor;
  final Color backgroundDark;

  const _RecCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.dist,
    required this.tags,
    required this.primaryColor,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundDark.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    dist,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: tags
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
