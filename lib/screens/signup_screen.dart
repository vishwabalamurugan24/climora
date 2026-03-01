
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryCream = Color(0xFFF5F5F0);
    const backgroundDarkTeal = Color(0xFF162624);
    const inputBackgroundTeal = Color(0xFF101C1A);
    const textLightGray = Color(0xFFB0B0B0);

    return Scaffold(
      backgroundColor: backgroundDarkTeal,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Join',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Climora',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Sub-header
                Text(
                  'Create an account to start your wellness journey.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: textLightGray,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 48),

                // Form config
                const _SignupForm(
                  primaryCream: primaryCream,
                  inputBackground: inputBackgroundTeal,
                ),

                const SizedBox(height: 40),

                // Social Signup / Footer
                const _SocialSection(inputBackground: inputBackgroundTeal),

                const SizedBox(height: 48),

                // Log In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.inter(
                        color: textLightGray,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

class _SignupForm extends StatelessWidget {
  final Color primaryCream;
  final Color inputBackground;

  const _SignupForm({
    required this.primaryCream,
    required this.inputBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InputBox(
          hint: 'Full Name',
          icon: Icons.person_outline,
          inputBackground: inputBackground,
        ),
        const SizedBox(height: 16),
        _InputBox(
          hint: 'Email Address',
          icon: Icons.mail_outline,
          inputBackground: inputBackground,
        ),
        const SizedBox(height: 16),
        _InputBox(
          hint: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
          inputBackground: inputBackground,
        ),
        const SizedBox(height: 32),
        // Submit Button
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryCream,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: primaryCream.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF162624),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF162624),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final Color inputBackground;

  const _InputBox({
    required this.hint,
    required this.icon,
    this.isPassword = false,
    required this.inputBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              obscureText: isPassword,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: const Color(0xFFB0B0B0)),
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
  final Color inputBackground;

  const _SocialSection({required this.inputBackground});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR SIGN UP WITH',
                style: GoogleFonts.inter(
                  color: const Color(0xFFB0B0B0),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                iconWidget: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAJNumS0cGtgysZVt76kA0A6Pnk3tA5wxMHKyVfr9ZlJziHEskvS_PUdeZEhQphfJjWdfaSiApTJ7i1RpGhKZT_rYlDkkMFy7yNIklqo7VI4aniGoTBHg91ftiw4bDmncUQgsnxfxnhbM1L3QG7chjargOQgYUb3rq_Yo0ySGiFJX4r6jU__MW_t58ES3dZ0MMe_eA2R6COVh1TDUf59rD3ZV8jTq7aAJv3dr59CU-vbKCYpV2L66NgF40NZXw1jP3RM-40Q7kbIuW2',
                  width: 20,
                  height: 20,
                ),
                label: 'Google',
                inputBackground: inputBackground,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SocialButton(
                iconWidget: const Icon(
                  Icons.phone_outlined,
                  color: Colors.white70,
                  size: 20,
                ),
                label: 'Phone',
                inputBackground: inputBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final Color inputBackground;

  const _SocialButton({
    required this.iconWidget,
    required this.label,
    required this.inputBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
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
