import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF0A1A1A);
    const tealDeep = Color(0xFF041414);
    const tealAccent = Color(0xFF0D2D2D);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Mesh
          const _MeshBackground(
            backgroundDark: backgroundDark,
            tealAccent: tealAccent,
            primaryColor: primaryColor,
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    const _LogoSection(primaryColor: primaryColor),

                    const SizedBox(height: 40),

                    // Title & Subtitle
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(text: 'Welcome back to your '),
                          TextSpan(
                            text: 'sonic sanctuary',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sync your mood with the atmosphere',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Login Form
                    const _LoginForm(primaryColor: primaryColor),

                    const SizedBox(height: 40),

                    // Social Login / Footer
                    const _SocialSection(
                      primaryColor: primaryColor,
                      tealDeep: tealDeep,
                    ),

                    const SizedBox(height: 48),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New to Climora?',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/signup'),
                          child: Text(
                            'Create an Account',
                            style: GoogleFonts.spaceGrotesk(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeshBackground extends StatelessWidget {
  final Color backgroundDark;
  final Color tealAccent;
  final Color primaryColor;

  const _MeshBackground({
    required this.backgroundDark,
    required this.tealAccent,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: backgroundDark),
        // Top Left Orb
        Positioned(
          top: -150,
          left: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tealAccent.withValues(alpha: 0.2),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Bottom Right Orb
        Positioned(
          bottom: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withValues(alpha: 0.04),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Center Dark Base
        Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  const Color(0xFF041414).withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  final Color primaryColor;
  const _LogoSection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAix78C_FbvqLA-PBZOEgBqcE6lpO3F3CEN8rBaXyaBNoOAB1lWQloAptEdpB29Koa6g_XmK94jHXp6_ATrzZhPnWSdBCtctHMC8J3dFUmwoKGSahlT-inXxnzw8KUOn2w9gwoHa9gA56d0TQ8RsgqzkcpbKZ2IpWXO0iypch8u-Lc9Fkz4A4p-qrubeBm1yaEOGjCPPAFo7VRX1KfhWqXLpsrwm9NON820aOlbcCwq1wFXv5xldw044b3oCXQMPpZObphMpXoUyImR',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final Color primaryColor;
  const _LoginForm({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        _Label(text: 'Email Address'),
        const SizedBox(height: 8),
        _GlassInput(
          hint: 'name@example.com',
          icon: Icons.mail_outline,
          primaryColor: primaryColor,
        ),

        const SizedBox(height: 24),

        // Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Label(text: 'Password'),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.spaceGrotesk(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _GlassInput(
          hint: '••••••••',
          icon: Icons.lock_outline,
          isPassword: true,
          primaryColor: primaryColor,
        ),

        const SizedBox(height: 32),

        // Submit Button
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Sanctuary',
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF041414),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Color(0xFF041414)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final Color primaryColor;

  const _GlassInput({
    required this.hint,
    required this.icon,
    this.isPassword = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              obscureText: isPassword,
              style: GoogleFonts.spaceGrotesk(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.spaceGrotesk(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (isPassword)
            Icon(
              Icons.visibility_outlined,
              color: Colors.white.withValues(alpha: 0.4),
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _SocialSection extends StatelessWidget {
  final Color primaryColor;
  final Color tealDeep;
  const _SocialSection({required this.primaryColor, required this.tealDeep});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.05)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white.withValues(alpha: 0.2),
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                iconUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAJNumS0cGtgysZVt76kA0A6Pnk3tA5wxMHKyVfr9ZlJziHEskvS_PUdeZEhQphfJjWdfaSiApTJ7i1RpGhKZT_rYlDkkMFy7yNIklqo7VI4aniGoTBHg91ftiw4bDmncUQgsnxfxnhbM1L3QG7chjargOQgYUb3rq_Yo0ySGiFJX4r6jU__MW_t58ES3dZ0MMe_eA2R6COVh1TDUf59rD3ZV8jTq7aAJv3dr59CU-vbKCYpV2L66NgF40NZXw1jP3RM-40Q7kbIuW2',
                label: 'Google',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialButton(
                iconUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAvUGJ97lmVKFf0hCYYrpVh_4srmZO4g5OiTdr-9Us0t-VCkIvX_AU50jZyyMMuX8Zbz7L0af6bCKN3K3TktWr0qbiSPHmWSGfFlRUOhFVZs7KLvXW23F2eK7BYnfdbUGpfhwQ5QwmwQ5ViC6gcQd0dv5A5XRRv5FU4NKQDtVRNJk78LK2PWxUNiN27M1xpK57iZcrLBlRz7wAbIplwRXoXaT1MXIwmMRuhLLcB76AZi4AM3BR8PjGcwo_OK1DgBygtCbBi3RiFdoKu',
                label: 'Apple',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String iconUrl;
  final String label;

  const _SocialButton({required this.iconUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(iconUrl, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
