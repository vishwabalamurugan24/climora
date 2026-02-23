import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC2B180);
    const backgroundDark = Color(0xFF0A1A1A);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Mesh
          const _MeshBackground(primaryColor: primaryColor),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: Column(
                  children: [
                    // Logo Section
                    const _LogoSection(primaryColor: primaryColor),

                    const SizedBox(height: 32),

                    // Signup Form Card
                    _SignupCard(
                      primaryColor: primaryColor,
                      backgroundDark: backgroundDark,
                    ),

                    const SizedBox(height: 32),

                    // Footer Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: Text(
                            'Log In',
                            style: GoogleFonts.spaceGrotesk(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
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
  final Color primaryColor;
  const _MeshBackground({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF061111),
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [Color(0xFF132D2D), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [Color(0xFF1C3E3E), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [
                  primaryColor.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Visual Depth Orbs
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withValues(alpha: 0.05),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
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
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDJCuGOe_qLqiE25O_v5-3LsvLK5LJ-VSX01JlYhu1pb2PWfN1iq52TtUiL8QBQNoxlqowTZkay6oh7aToOjkXVD_NDUY45JdPO89c1WCvehUkc7lzFlz1DajdBM1P8dbD4GU7fhQ0UL2Bpa72ThjZtZGqiLznugtoTpmQ8vyGmbCZpcxD4Rv6rXp46wsWqSgn6aelBqv3o65PM1GD1ttSAT45NTGIB3dsOnrpJY4EEC5MBAffuLDdgxWn8md9Lnm6MTY3SSs9VmBKr',
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.white,
            ),
            children: [
              const TextSpan(text: 'CLIMORA '),
              TextSpan(
                text: 'AI',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'The future of intelligence is here.',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _SignupCard extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundDark;

  const _SignupCard({required this.primaryColor, required this.backgroundDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Create Your Account',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const _SignupInput(
            label: 'Full Name',
            hint: 'John Doe',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          const _SignupInput(
            label: 'Email Address',
            hint: 'name@example.com',
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 20),
          const _SignupInput(
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Create Account',
                  style: GoogleFonts.spaceGrotesk(
                    color: backgroundDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(color: Colors.white.withValues(alpha: 0.1)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR SIGN UP WITH',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Social Buttons
          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  icon: 'google',
                  label: 'Google',
                  backgroundDark: backgroundDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SocialButton(
                  icon: 'apple',
                  label: 'Apple',
                  backgroundDark: backgroundDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignupInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;

  const _SignupInput({
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.3), size: 20),
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
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 20,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final Color backgroundDark;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.backgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Simplified icons for placeholder
          Icon(
            icon == 'google' ? Icons.g_mobiledata : Icons.apple,
            color: Colors.white70,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
