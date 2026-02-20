import 'package:flutter/material.dart';
import 'dart:math' as math;

class VoiceOrb extends StatefulWidget {
  final bool isListening;
  final double volume;

  const VoiceOrb({super.key, required this.isListening, this.volume = 0.0});

  @override
  State<VoiceOrb> createState() => _VoiceOrbState();
}

class _VoiceOrbState extends State<VoiceOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double pulse = widget.isListening
            ? 1.0 + (widget.volume * 0.5)
            : 1.0;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow shadows
              for (int i = 0; i < 3; i++)
                Transform.scale(
                  scale: pulse * (1.0 + (i * 0.2 * _controller.value)),
                  child: Opacity(
                    opacity: (1.0 - _controller.value) * (0.3 / (i + 1)),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withValues(alpha: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // The main orb
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _OrbPainter(
                    _controller.value,
                    widget.isListening ? widget.volume : 0.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double animationValue;
  final double volume;

  _OrbPainter(this.animationValue, this.volume);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final double offset =
          (animationValue * 2 * math.pi) + (i * math.pi / 2.5);

      for (double t = 0; t <= 2 * math.pi; t += 0.1) {
        final double r =
            radius * (0.8 + 0.1 * math.sin(t * 3 + offset) * (1 + volume * 2));
        final double x = center.dx + r * math.cos(t);
        final double y = center.dy + r * math.sin(t);
        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbPainter oldDelegate) => true;
}
