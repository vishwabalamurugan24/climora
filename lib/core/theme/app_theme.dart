import 'package:flutter/material.dart';
import 'dart:ui';

class AppTheme {
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color accentPurple = Color(0xFF9B51E0);
  static const Color surfaceGlass = Color(0x33FFFFFF);
  static const Color textMain = Color(0xFFF2F2F2);
  static const Color textSecondary = Color(0xFFAAAAAA);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentPurple,
        surface: Colors.transparent,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textMain),
        bodySmall: TextStyle(fontSize: 12, color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceGlass,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white12, width: 1),
        ),
        elevation: 0,
      ),
    );
  }

  static Widget glassBox({required Widget child, double blur = 8.0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),

        child: Container(
          decoration: BoxDecoration(
            color: surfaceGlass,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
