import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breatheController;
  late final AnimationController _floatController;
  late final AnimationController _pulseGlowController;
  late final AnimationController _geometrySpinController;

  @override
  void initState() {
    super.initState();

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _pulseGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _geometrySpinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _floatController.dispose();
    _pulseGlowController.dispose();
    _geometrySpinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sanctuary;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // ═══════════════════════════════════════════════════════════════
          // Atmospheric Background Auroras
          // ═══════════════════════════════════════════════════════════════
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  // Top teal aurora
                  AnimatedBuilder(
                    animation: _pulseGlowController,
                    builder: (context, child) {
                      final opacity =
                          (0.10 + (_pulseGlowController.value * 0.08)) *
                          (colors.isDark ? 1.0 : 0.6);
                      return Positioned(
                        top: -80,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 420,
                            height: 420,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  (colors.isDark
                                          ? const Color.fromRGBO(
                                              16,
                                              185,
                                              129,
                                              1.0,
                                            )
                                          : const Color(0xFF14B8A6))
                                      .withValues(alpha: opacity),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Left teal aura
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.22,
                    left: -60,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colors.primary.withValues(
                              alpha: colors.isDark ? 0.10 : 0.06,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Right cyan aura
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.38,
                    right: -60,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (colors.isDark
                                    ? const Color(0xFF06B6D4)
                                    : const Color(0xFF0D9488))
                                .withValues(alpha: colors.isDark ? 0.08 : 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom teal aura
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 340,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(110),
                          gradient: RadialGradient(
                            colors: [
                              colors.primary.withValues(
                                alpha: colors.isDark ? 0.10 : 0.06,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gold accent aura (upper right)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.10,
                    right: 0,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colors.gold.withValues(
                              alpha: colors.isDark ? 0.05 : 0.04,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ═══════════════════════════════════════════════════════════════
          // Main Content
          // ═══════════════════════════════════════════════════════════════
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Top action row: Spa icon
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildSpaButton(context),
                    ),
                  ),

                  // Expanding center hero
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            _buildBioluminescentSphere(context),
                            const SizedBox(height: 30),
                            _buildScrollGuardBadge(context),
                            const SizedBox(height: 22),
                            _buildHeadline(context),
                            const SizedBox(height: 16),
                            _buildSubtitle(context),
                            const SizedBox(height: 28),
                            _buildPracticeChips(context),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom action area
                  _buildBottomActions(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SPA BUTTON (Top Right)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSpaButton(BuildContext context) {
    final colors = context.sanctuary;

    return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceCard,
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: colors.isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(Icons.spa_rounded, size: 20, color: colors.primary),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BIOLUMINESCENT SPHERE (Central Artwork)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBioluminescentSphere(BuildContext context) {
    final colors = context.sanctuary;

    return AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final floatOffset =
                -6.0 * math.sin(_floatController.value * math.pi);
            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: child,
            );
          },
          child: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Stardust particles
                  _buildStardustParticle(
                    top: -6,
                    left: 28,
                    size: 3,
                    color: const Color(0xFF6EE7B7),
                    delay: 0,
                  ),
                  _buildStardustParticle(
                    top: 50,
                    left: -12,
                    size: 2.5,
                    color: const Color(0xFF99F6E4),
                    delay: 1200,
                  ),
                  _buildStardustParticle(
                    bottom: 16,
                    right: -8,
                    size: 3,
                    color: const Color(0xFF67E8F9),
                    delay: 2100,
                  ),
                  _buildStardustParticle(
                    bottom: -4,
                    left: 48,
                    size: 2,
                    color: colors.gold,
                    delay: 800,
                  ),

                  // Outer expanding breathing ripple
                  AnimatedBuilder(
                    animation: _breatheController,
                    builder: (context, child) {
                      final scale = 1.0 + (_breatheController.value * 0.06);
                      final opacity = 0.88 - (_breatheController.value * 0.12);
                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity.clamp(0.0, 1.0),
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.primary.withValues(
                                  alpha: colors.isDark ? 0.10 : 0.15,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Inner aura ring
                  Container(
                    width: 206,
                    height: 206,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(
                          alpha: colors.isDark ? 0.20 : 0.25,
                        ),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(
                            alpha: colors.isDark ? 0.15 : 0.10,
                          ),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  ),

                  // Rotating sacred geometry behind sphere
                  AnimatedBuilder(
                    animation: _geometrySpinController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _geometrySpinController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _WelcomeGeometryPainter(
                        color: colors.primary.withValues(
                          alpha: colors.isDark ? 0.10 : 0.12,
                        ),
                      ),
                    ),
                  ),

                  // Main bioluminescent sphere (breathing)
                  AnimatedBuilder(
                    animation: _breatheController,
                    builder: (context, child) {
                      final scale = 1.0 + (_breatheController.value * 0.06);
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 192,
                      height: 192,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colors.isDark
                              ? const [
                                  Color(0x6614B8A6),
                                  Color(0x3322D3EE),
                                  Color(0x4D6EE7B7),
                                ]
                              : const [
                                  Color(0x992DD4BF),
                                  Color(0x660D9488),
                                  Color(0x805EEAD4),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.isDark
                                ? const Color(
                                    0xFF134E4A,
                                  ).withValues(alpha: 0.80)
                                : colors.primary.withValues(alpha: 0.25),
                            blurRadius: 40,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.isDark
                              ? const Color(0xFF071317)
                              : const Color(0xFFF0FDFA),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.30),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(
                                alpha: colors.isDark ? 0.18 : 0.10,
                              ),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: colors.primary.withValues(
                                alpha: colors.isDark ? 0.25 : 0.15,
                              ),
                              blurRadius: 35,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // App logo
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/icon/logo.png',
                                  width: 176,
                                  height: 176,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            // Inner vignette
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    (colors.isDark
                                            ? Colors.black
                                            : const Color(0xFF0F172A))
                                        .withValues(
                                          alpha: colors.isDark ? 0.50 : 0.20,
                                        ),
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 900.ms)
        .scaleXY(
          begin: 0.85,
          end: 1.0,
          curve: Curves.easeOutBack,
          duration: 900.ms,
        );
  }

  Widget _buildStardustParticle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required int delay,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(duration: 1200.ms, delay: delay.ms)
              .then()
              .fadeOut(duration: 1200.ms),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCROLLGUARD BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildScrollGuardBadge(BuildContext context) {
    final colors = context.sanctuary;

    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colors.surfaceCard,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pinging dot
              SizedBox(
                width: 10,
                height: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF34D399,
                            ).withValues(alpha: 0.0),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat())
                        .scaleXY(
                          begin: 0.5,
                          end: 2.0,
                          duration: 1500.ms,
                          curve: Curves.easeOut,
                        )
                        .fadeOut(duration: 1500.ms),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.7),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'SCROLLGUARD',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 500.ms)
        .scaleXY(begin: 0.9, end: 1.0, curve: Curves.easeOut);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeadline(BuildContext context) {
    final colors = context.sanctuary;

    return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors.isDark
                ? const [Colors.white, Color(0xFFA7F3D0), Color(0xFF57F1DB)]
                : [
                    const Color(0xFF0F172A),
                    colors.primary,
                    colors.primaryContainer,
                  ],
            stops: const [0.3, 0.65, 1.0],
          ).createShader(bounds),
          child: Text(
            'Make your pauses\ncount.',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color: colors.isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
              fontSize: 32,
              height: 1.18,
              letterSpacing: -0.5,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms, delay: 700.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBTITLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSubtitle(BuildContext context) {
    final colors = context.sanctuary;

    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Set a limit for the apps you scroll. When time is up, take a moment to breathe or remember Allah.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textSecondary,
              fontSize: 14.5,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 900.ms)
        .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRACTICE CHIPS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPracticeChips(BuildContext context) {
    final colors = context.sanctuary;

    final chips = [
      (Icons.air_rounded, 'Deep breath'),
      (Icons.menu_book_rounded, 'Dhikr'),
      (Icons.self_improvement_rounded, 'Reflect'),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: chips.asMap().entries.map((entry) {
        final index = entry.key;
        final chip = entry.value;
        return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: colors.surfaceCard,
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: colors.isDark
                        ? Colors.black.withValues(alpha: 0.45)
                        : const Color(0xFF0F172A).withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(chip.$1, size: 15, color: colors.primary),
                  const SizedBox(width: 6),
                  Text(
                    chip.$2,
                    style: AppTypography.labelSmall.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: (1100 + index * 120).ms)
            .scaleXY(begin: 0.85, end: 1.0, curve: Curves.easeOutBack);
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomActions(BuildContext context) {
    final colors = context.sanctuary;

    return Column(
      children: [
        // Radiant Glowing Mint Button
        Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    colors.primary,
                    colors.isDark
                        ? const Color(0xFF57F1DB)
                        : const Color(0xFF0F766E),
                    colors.primaryContainer,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.38),
                    blurRadius: 28,
                    spreadRadius: -4,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => context.push(Routes.appSelection),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get started',
                      style: AppTypography.labelLarge.copyWith(
                        color: colors.isDark
                            ? const Color(0xFF003731)
                            : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colors.isDark
                          ? const Color(0xFF003731)
                          : Colors.white,
                      size: 19,
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 700.ms, delay: 1400.ms)
            .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 10),

        // Subtitle disclaimer
        Text(
          'You can change your pause activity anytime.',
          style: AppTypography.bodySmall.copyWith(
            color: colors.textTertiary,
            fontSize: 12.5,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 1600.ms),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SACRED GEOMETRY PAINTER (Welcome Screen Variant)
// ═══════════════════════════════════════════════════════════════════════════

class _WelcomeGeometryPainter extends CustomPainter {
  final Color color;

  _WelcomeGeometryPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    // Concentric circles
    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawCircle(Offset(cx, cy), r * 0.7, paint);

    // 6-petal rosette
    for (int i = 0; i < 6; i++) {
      final angle = i * (math.pi / 3);
      final px = cx + (r * 0.7) * math.cos(angle);
      final py = cy + (r * 0.7) * math.sin(angle);
      canvas.drawCircle(Offset(px, py), r * 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeGeometryPainter oldDelegate) =>
      oldDelegate.color != color;
}
