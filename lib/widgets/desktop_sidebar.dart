import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopSidebar extends StatelessWidget {
  final Color primaryColor;
  final String currentRoute;

  const DesktopSidebar({
    super.key,
    required this.primaryColor,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          // Logo & Title
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.blur_on_rounded, color: primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Climora AI',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ATMOSPHERIC SOUND',
                      style: GoogleFonts.spaceGrotesk(
                        color: primaryColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Nav Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SidebarItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Dashboard',
                    isActive: currentRoute == '/home',
                    primaryColor: primaryColor,
                    onTap: () => _navigate(context, '/home'),
                  ),
                  _SidebarItem(
                    icon: Icons.explore_outlined,
                    label: 'Discovery',
                    isActive: currentRoute == '/explore',
                    primaryColor: primaryColor,
                    onTap: () => _navigate(context, '/explore'),
                  ),
                  _SidebarItem(
                    icon: Icons.map_outlined,
                    label: 'Atmospheric Map',
                    isActive: currentRoute == '/map',
                    primaryColor: primaryColor,
                    onTap: () => _navigate(context, '/map'),
                  ),
                  _SidebarItem(
                    icon: Icons.auto_awesome_outlined,
                    label: 'AI Playlists',
                    isActive: currentRoute == '/playlist',
                    primaryColor: primaryColor,
                    onTap: () => _navigate(context, '/playlist'),
                  ),
                  _SidebarItem(
                    icon: Icons.air_rounded,
                    label: 'Environmental Sync',
                    isActive: currentRoute == '/weather',
                    primaryColor: primaryColor,
                    onTap: () => _navigate(context, '/weather'),
                  ),
                  _SidebarItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isActive: currentRoute == '/profile',
                    primaryColor: primaryColor,
                    onTap: () => _navigate(context, '/profile'),
                  ),
                ],
              ),
            ),
          ),

          // Pro Plan Box
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRO PLAN',
                    style: GoogleFonts.spaceGrotesk(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock lossless climate streaming.',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white60,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Upgrade Now',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (currentRoute == route) return;
    Navigator.pushReplacementNamed(context, route);
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color primaryColor;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isActive
              ? Border.all(color: primaryColor.withValues(alpha: 0.2))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? primaryColor : Colors.white60,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: isActive ? primaryColor : Colors.white60,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
