import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Bespoke, high-fidelity vector icons designed for the Digital Sanctuary experience.
/// Rendered directly on the GPU Canvas for razor-sharp, glowing mindfulness aesthetics.

/// 1. Sacred Tasbih / Dhikr Prayer Beads Icon
class DhikrBeadsIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final bool glowing;

  const DhikrBeadsIcon({
    super.key,
    this.size = 24,
    this.color,
    this.glowing = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DhikrBeadsPainter(
          color: effectiveColor,
          glowing: glowing,
        ),
      ),
    );
  }
}

class _DhikrBeadsPainter extends CustomPainter {
  final Color color;
  final bool glowing;

  _DhikrBeadsPainter({required this.color, required this.glowing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.44);
    final radius = size.width * 0.32;
    const beadCount = 11;

    // Draw connecting loop line
    final loopPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045;
    canvas.drawCircle(center, radius, loopPaint);

    // Draw individual beads
    for (int i = 0; i < beadCount; i++) {
      final angle = (i * 2 * math.pi / beadCount) - (math.pi / 2);
      final bx = center.dx + radius * math.cos(angle);
      final by = center.dy + radius * math.sin(angle);
      final beadRadius = (i == 0) ? size.width * 0.095 : size.width * 0.065;

      if (glowing && i == 0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(bx, by), beadRadius * 1.5, glowPaint);
      }

      final beadPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
          colors: [
            Colors.white,
            color,
            color.withValues(alpha: 0.8),
          ],
        ).createShader(Rect.fromCircle(center: Offset(bx, by), radius: beadRadius));

      canvas.drawCircle(Offset(bx, by), beadRadius, beadPaint);
    }

    // Draw Tassel / Imame at the bottom
    final tasselStartX = center.dx;
    final tasselStartY = center.dy + radius + (size.width * 0.05);
    final tasselEndY = size.height * 0.95;

    final tasselPaint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.055
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(tasselStartX, tasselStartY),
      Offset(tasselStartX, tasselEndY),
      tasselPaint,
    );

    // Mini tassel bead
    final tasselBeadPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(tasselStartX, tasselStartY + (tasselEndY - tasselStartY) * 0.4),
      size.width * 0.045,
      tasselBeadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DhikrBeadsPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.glowing != glowing;
  }
}

/// 2. Harmonic Box Breathing / Prana Flow Waveform Icon
class BreathingFlowIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const BreathingFlowIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BreathingFlowPainter(color: effectiveColor),
      ),
    );
  }
}

class _BreathingFlowPainter extends CustomPainter {
  final Color color;

  _BreathingFlowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Stream 1 (Top harmonic wave)
    final paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(w * 0.15, h * 0.32)
      ..cubicTo(w * 0.4, h * 0.16, w * 0.6, h * 0.48, w * 0.85, h * 0.32);
    canvas.drawPath(path1, paint1);

    // Stream 2 (Middle expanded breath)
    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round;

    final path2 = Path()
      ..moveTo(w * 0.1, h * 0.52)
      ..cubicTo(w * 0.35, h * 0.72, w * 0.65, h * 0.32, w * 0.9, h * 0.52);
    canvas.drawPath(path2, paint2);

    // Stream 3 (Bottom grounding wave)
    final paint3 = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final path3 = Path()
      ..moveTo(w * 0.25, h * 0.74)
      ..cubicTo(w * 0.45, h * 0.62, w * 0.6, h * 0.86, w * 0.8, h * 0.74);
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant _BreathingFlowPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// 3. ScrollGuard Luminous Shield & Sanctum Emblem
class SanctuaryShieldIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const SanctuaryShieldIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SanctuaryShieldPainter(color: effectiveColor),
      ),
    );
  }
}

class _SanctuaryShieldPainter extends CustomPainter {
  final Color color;

  _SanctuaryShieldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Shield Path
    final shieldPath = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..cubicTo(w * 0.75, h * 0.08, w * 0.88, h * 0.2, w * 0.88, h * 0.45)
      ..cubicTo(w * 0.88, h * 0.72, w * 0.65, h * 0.88, w * 0.5, h * 0.94)
      ..cubicTo(w * 0.35, h * 0.88, w * 0.12, h * 0.72, w * 0.12, h * 0.45)
      ..cubicTo(w * 0.12, h * 0.2, w * 0.25, h * 0.08, w * 0.5, h * 0.08)
      ..close();

    final outerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(shieldPath, outerPaint);

    // Inner Radiant Lotus/Heart Core
    final center = Offset(w * 0.5, h * 0.48);
    final coreRadius = w * 0.16;

    final corePaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreRadius, corePaint);

    final sparkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreRadius * 0.45, sparkPaint);
  }

  @override
  bool shouldRepaint(covariant _SanctuaryShieldPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// 4. Celestial Crescent Moon & Radiant Star
class CelestialMoonIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const CelestialMoonIcon({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CelestialMoonPainter(color: effectiveColor),
      ),
    );
  }
}

class _CelestialMoonPainter extends CustomPainter {
  final Color color;

  _CelestialMoonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Crescent Moon
    final moonPath = Path();
    moonPath.addArc(
      Rect.fromCircle(center: Offset(w * 0.42, h * 0.5), radius: w * 0.38),
      -math.pi * 0.65,
      math.pi * 1.3,
    );
    moonPath.arcTo(
      Rect.fromCircle(center: Offset(w * 0.54, h * 0.5), radius: w * 0.32),
      math.pi * 0.65,
      -math.pi * 1.3,
      false,
    );
    moonPath.close();

    final moonPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(moonPath, moonPaint);

    // Four-Point Radiant Star
    final starCenter = Offset(w * 0.78, h * 0.32);
    final starRadius = w * 0.13;

    final starPath = Path()
      ..moveTo(starCenter.dx, starCenter.dy - starRadius)
      ..cubicTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy, starCenter.dx + starRadius, starCenter.dy)
      ..cubicTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy + starRadius)
      ..cubicTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy, starCenter.dx - starRadius, starCenter.dy)
      ..cubicTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy - starRadius)
      ..close();

    final starPaint = Paint()
      ..color = AppColors.goldAccent
      ..style = PaintingStyle.fill;
    canvas.drawPath(starPath, starPaint);
  }

  @override
  bool shouldRepaint(covariant _CelestialMoonPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// 5. Mindful Heart / Spirit Pulse Icon
class MindfulHeartIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const MindfulHeartIcon({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MindfulHeartPainter(color: effectiveColor),
      ),
    );
  }
}

class _MindfulHeartPainter extends CustomPainter {
  final Color color;

  _MindfulHeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.5, h * 0.82)
      ..cubicTo(w * 0.15, h * 0.55, w * 0.1, h * 0.28, w * 0.32, h * 0.18)
      ..cubicTo(w * 0.44, h * 0.13, w * 0.5, h * 0.25, w * 0.5, h * 0.32)
      ..cubicTo(w * 0.5, h * 0.25, w * 0.56, h * 0.13, w * 0.68, h * 0.18)
      ..cubicTo(w * 0.9, h * 0.28, w * 0.85, h * 0.55, w * 0.5, h * 0.82)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);

    // Mini inner glowing seed
    final seedPaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.44), w * 0.12, seedPaint);
  }

  @override
  bool shouldRepaint(covariant _MindfulHeartPainter oldDelegate) =>
      oldDelegate.color != color;
}


