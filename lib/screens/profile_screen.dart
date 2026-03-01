import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/climora_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color(0xFF0F1C1A);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  // Header Section
                  const _ProfileHeader(),

                  const SizedBox(height: 16),

                  // Profile Identity
                  const _ProfileIdentity(),

                  const SizedBox(height: 40),

                  // Settings Grid
                  const _SettingsGrid(),
                ],
              ),
            ),
          ),

          // Glass Floating Navigation Bar
          const ClimoraBottomNav(currentRoute: '/profile'),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderButton(
            icon: Icons.chevron_left_rounded,
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          Text(
            'PROFILE',
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          _HeaderButton(icon: Icons.more_vert_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderButton({required this.icon, required this.onTap});

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

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity();

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryCream.withValues(alpha: 0.4),
                  width: 2,
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCxj3h01Wjwg6Muiu0pbKbXmEnH_hJwXuYLnYASeUQ50xLjVJQm-XoLxmHn0TRwMJhzAPMBGT9x2wNaPHJHQyarPA83vbm4c_DOfoURJ68DEGMWbHdI5O8sIr0nkC2aKGWMgmigGPk82UoI8-q9LY2cfNB0e9qpk-jT_wEBY9CAsK9p_DRvVJdjQs13MsDNYvLxHi5Eq2OT5oTo41mGPLlMHh3f6dHD3x36oKYP4zIu_scv8qsrN5pEhTySh81z9iFb0bGVfiC_za3f',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryCream.withValues(alpha: 0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: primaryCream,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0F1C1A), width: 4),
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 14,
                color: Color(0xFF0F1C1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Alex Rivera',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF142925),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PRO MEMBER',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEFE6D5),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('•', style: TextStyle(color: Color(0xFF5D7B75))),
            const SizedBox(width: 8),
            Text(
              'Climora Enthusiast',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5D7B75),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsGrid extends StatelessWidget {
  const _SettingsGrid();

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const _SettingTile(
            icon: Icons.person_outline_rounded,
            title: 'Account Settings',
            subtitle: 'Personal info & privacy',
          ),
          const SizedBox(height: 16),
          const _ClimateSyncTile(),
          const SizedBox(height: 16),
          const _AudioQualityTile(),
          const SizedBox(height: 16),
          _SettingTile(
            icon: Icons.insights_rounded,
            title: 'Mood History',
            subtitle: 'AI emotional tracking logs',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryCream.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '+12%',
                style: TextStyle(
                  fontSize: 10,
                  color: primaryCream,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SubscriptionTile(),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryCream.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryCream, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D7B75),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF5D7B75).withValues(alpha: 0.5),
              ),
        ],
      ),
    );
  }
}

class _ClimateSyncTile extends StatelessWidget {
  const _ClimateSyncTile();

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryCream.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryCream.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_sync_rounded,
                      color: primaryCream,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Climate Sync',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Active - Rainy Mode',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryCream,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: true,
                onChanged: (val) {},
                thumbColor: const WidgetStatePropertyAll(primaryCream),
                activeTrackColor: primaryCream.withValues(alpha: 0.3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryCream.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const _NavButton(
                  icon: Icons.add_chart_rounded,
                  label: 'Insights',
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'AI is currently optimizing audio for interior acoustics during rainfall.',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D7B75),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioQualityTile extends StatelessWidget {
  const _AudioQualityTile();

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);
    const Color bgDark = Color(0xFF0F1C1A);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryCream.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.graphic_eq_rounded,
                      color: primaryCream,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio Quality',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Adaptive Lossless',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5D7B75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: true,
                onChanged: (val) {},
                thumbColor: const WidgetStatePropertyAll(primaryCream),
                activeTrackColor: primaryCream.withValues(alpha: 0.3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryCream,
                    foregroundColor: bgDark,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'HIGH RES',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'STANDARD',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile();

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF142925),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryCream.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryCream.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: primaryCream,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscription',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Next billing on June 12, 2024',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D7B75),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'MANAGE',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: primaryCream,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xFF5D7B75);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: iconColor),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: iconColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
