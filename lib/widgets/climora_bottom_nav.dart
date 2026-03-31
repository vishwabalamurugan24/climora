import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClimoraBottomNav extends StatelessWidget {
  final String currentRoute;
  final Color primaryColor;
  final Color backgroundDark;

  const ClimoraBottomNav({
    super.key,
    required this.currentRoute,
    this.primaryColor = const Color(0xFFC2B180),
    this.backgroundDark = const Color(0xFF0A1F1F),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentRoute == '/home',
                  primaryColor: primaryColor,
                  onTap: () => _navigate(context, '/home'),
                ),
                _NavItem(
                  icon: Icons.explore_rounded,
                  label: 'Explore',
                  isActive: currentRoute == '/explore',
                  primaryColor: primaryColor,
                  onTap: () => _navigate(context, '/explore'),
                ),
                _NavCenterItem(
                  primaryColor: primaryColor,
                  backgroundDark: backgroundDark,
                  onTap: () => _navigate(context, '/player'),
                ),
                _NavItem(
                  icon: Icons.map_rounded,
                  label: 'Map',
                  isActive:
                      currentRoute == '/map' || currentRoute == '/navigation',
                  primaryColor: primaryColor,
                  onTap: () => _navigate(context, '/map'),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: currentRoute == '/profile',
                  primaryColor: primaryColor,
                  onTap: () => _navigate(context, '/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (currentRoute == route) return;

    // For primary screens, we use pushReplacementNamed to avoid deep stacks
    // except for player/profile which might be overlays or sub-pages in some flows
    if (route == '/home') {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color primaryColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? primaryColor : Colors.grey.withValues(alpha: 0.6);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
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
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCenterItem extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;
  final VoidCallback onTap;

  const _NavCenterItem({
    required this.primaryColor,
    required this.backgroundDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -24,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            top: -24,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.bolt_rounded, size: 36, color: backgroundDark),
            ),
          ),
        ],
      ),
    );
  }
}
