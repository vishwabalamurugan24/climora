import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/weather_theme.dart';

class WeatherGlassCard extends StatelessWidget {
  final Widget child;
  final WeatherTheme theme;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onTap;
  
  const WeatherGlassCard({
    Key? key,
    required this.child,
    required this.theme,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: theme.secondaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
