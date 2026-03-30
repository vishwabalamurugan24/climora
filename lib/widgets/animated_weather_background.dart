import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // modified flutter_lottie import since user's alternative
import '../theme/weather_theme.dart';

class AnimatedWeatherBackground extends StatefulWidget {
  final WeatherTheme theme;
  final Widget child;
  
  const AnimatedWeatherBackground({
    super.key,
    required this.theme,
    required this.child,
  });
  
  @override
  State<AnimatedWeatherBackground> createState() => _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  List<Offset> _particles = [];
  
  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
    
    // Initialize particles
    _initParticles();
  }
  
  void _initParticles() {
    final random = Random();
    _particles = List.generate(50, (index) => Offset(
      random.nextDouble(),
      random.nextDouble(),
    ));
  }
  
  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: _buildAnimatedGradient(),
      ),
      child: Stack(
        children: [
          // Background animation (Lottie)
          if (widget.theme.animationAsset.isNotEmpty)
            Positioned.fill(
              child: Lottie.asset(
                widget.theme.animationAsset,
                fit: BoxFit.cover,
                repeat: true,
                reverse: false,
                animate: true,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink(); // Ignore if asset is not present
                },
              ),
            ),
          
          // Particle effects
          ..._buildParticles(),
          
          // Blur overlay for glassmorphism effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          
          // Main content
          widget.child,
        ],
      ),
    );
  }
  
  Gradient _buildAnimatedGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: widget.theme.backgroundGradient.colors,
      stops: widget.theme.backgroundGradient.stops,
      transform: _gradientGradientTransform(),
    );
  }
  
  GradientTransform _gradientGradientTransform() {
    return GradientRotation(_gradientController.value * 2 * pi);
  }
  
  List<Widget> _buildParticles() {
    return _particles.map((position) {
      return AnimatedPositioned(
        duration: Duration(seconds: Random().nextInt(5) + 3),
        left: position.dx * MediaQuery.of(context).size.width,
        top: position.dy * MediaQuery.of(context).size.height,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: Random().nextInt(3) + 2),
          builder: (context, value, child) {
            return Opacity(
              opacity: sin(value * pi).abs(),
              child: Container(
                width: Random().nextInt(5) + 2,
                height: Random().nextInt(5) + 2,
                decoration: BoxDecoration(
                  color: widget.theme.particleColors[
                    Random().nextInt(widget.theme.particleColors.length)
                  ],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.theme.accentColor.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

class GradientRotation extends GradientTransform {
  final double angle;
  
  const GradientRotation(this.angle);
  
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final center = bounds.center;
    return Matrix4.translationValues(center.dx, center.dy, 0)
      ..rotateZ(angle)
      // ignore: deprecated_member_use
      ..translate(-center.dx, -center.dy);
  }
}
