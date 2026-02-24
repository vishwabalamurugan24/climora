import 'package:flutter/material.dart';

class MapPathwayPainter extends CustomPainter {
  final double pulseValue;

  MapPathwayPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF14B8A6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xFF14B8A6).withValues(alpha: 0.4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Main Pathway Paths
    final path1 = Path();
    path1.moveTo(-50, size.height * 0.25);
    path1.lineTo(size.width * 0.4, size.height * 0.25);

    final path2 = Path();
    path2.moveTo(size.width * 0.2, -50);
    path2.lineTo(size.width * 0.2, size.height * 1.1);

    final path3 = Path();
    path3.moveTo(size.width * 0.4, size.height * 0.125);
    path3.lineTo(size.width * 0.8, size.height * 0.75);

    // Draw Glows
    canvas.drawPath(path1, glowPaint);
    canvas.drawPath(path2, glowPaint);
    canvas.drawPath(path3, glowPaint);

    // Draw Main Lines
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);

    // Secondary Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0xFF14B8A6).withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.1, 0),
      Offset(size.width * 0.1, size.height),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width, size.height * 0.45),
      gridPaint,
    );

    // Radar Center
    final center = Offset(size.width * 0.5, size.height * 0.45);

    // Pulse Circle
    final pulsePaint = Paint()
      ..color = const Color(
        0xFFC2B180,
      ).withValues(alpha: 0.3 * (1 - pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 20 + (pulseValue * 30), pulsePaint);

    // Main Dot
    final dotPaint = Paint()
      ..color = const Color(0xFFC2B180)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 6, dotPaint);

    // Inner Glow
    final innerGlowPaint = Paint()
      ..color = const Color(0xFFC2B180).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, 12, innerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant MapPathwayPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue;
  }
}
