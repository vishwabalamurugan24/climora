
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClimoraBottomNav extends StatelessWidget {
  final String currentRoute;

  const ClimoraBottomNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0C1615); // Deepest teal for bottom nav
    const activeIconColor = Color(0xFFF5F5F0);
    const activeLabelColor = Color(0xFFF5F5F0);
    const inactiveColor = Color(0xFF5D6B69);
    const activeBgColor = Color(0xFF14302C);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: bg,
              border: Border(
                top: BorderSide(color: Color(0xFF182A27), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_filled,
                  label: 'HOME',
                  isActive: currentRoute == '/home',
                  onTap: () => _navigate(context, '/home'),
                  activeIconColor: activeIconColor,
                  activeLabelColor: activeLabelColor,
                  inactiveColor: inactiveColor,
                  activeBgColor: activeBgColor,
                ),
                _NavItem(
                  icon: Icons.music_note_rounded,
                  label: 'MUSIC',
                  isActive:
                      currentRoute == '/playlist' || currentRoute == '/player',
                  onTap: () => _navigate(context, '/playlist'),
                  activeIconColor: activeIconColor,
                  activeLabelColor: activeLabelColor,
                  inactiveColor: inactiveColor,
                  activeBgColor: activeBgColor,
                ),
                const SizedBox(width: 48), // Space for floating mic
                _NavItem(
                  icon: Icons.explore_rounded,
                  label: 'PLACES',
                  isActive:
                      currentRoute == '/map' || currentRoute == '/explore',
                  onTap: () => _navigate(context, '/explore'),
                  activeIconColor: activeIconColor,
                  activeLabelColor: activeLabelColor,
                  inactiveColor: inactiveColor,
                  activeBgColor: activeBgColor,
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'PROFILE',
                  isActive: currentRoute == '/profile',
                  onTap: () => _navigate(context, '/profile'),
                  activeIconColor: activeIconColor,
                  activeLabelColor: activeLabelColor,
                  inactiveColor: inactiveColor,
                  activeBgColor: activeBgColor,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                // Voice action
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0F1C1A),
                  border: Border.all(color: const Color(0xFF1F3834), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic,
                  color: Color(0xFFB4C5C2),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (currentRoute == route) return;
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
  final VoidCallback onTap;
  final Color activeIconColor;
  final Color activeLabelColor;
  final Color inactiveColor;
  final Color activeBgColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    required this.activeIconColor,
    required this.activeLabelColor,
    required this.inactiveColor,
    required this.activeBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive ? activeIconColor : inactiveColor;
    final labelColor = isActive ? activeLabelColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? activeBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  color: labelColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
