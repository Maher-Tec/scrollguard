import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/monitored_app.dart';
import '../../../data/models/intervention_mode.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sanctuary;
    final settings = ref.watch(settingsProvider);
    final settingsData = settings.valueOrNull;
    final usage = ref.watch(usageProvider).valueOrNull;

    final timeLimit =
        settingsData?.timeLimitMinutes ?? AppConstants.defaultTimeLimit;
    final apps = settingsData?.monitoredApps ?? DefaultApps.all;
    final enabledAppsCount = apps.where((a) => a.isEnabled).length;
    final interventionMode =
        settingsData?.interventionMode ?? InterventionMode.both;
    final themeMode = settingsData?.themeMode ?? ThemeMode.dark;
    final hapticsEnabled = settingsData?.hapticsEnabled ?? true;
    final soundsEnabled = settingsData?.soundsEnabled ?? false;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // ═══════════════════════════════════════════════════════════════
          // Ambient Glow Backdrop Elements
          // ═══════════════════════════════════════════════════════════════
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 340,
                height: 340,
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
          ),
          Positioned(
            bottom: 40,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.primaryContainer.withValues(
                      alpha: colors.isDark ? 0.08 : 0.04,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ═══════════════════════════════════════════════════════════════
          // Scrollable Deck Content with Safe Area & Header
          // ═══════════════════════════════════════════════════════════════
          SafeArea(
            child: Column(
              children: [
                _buildHeaderDeck(context, colors, enabledAppsCount),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Conscious Friction Ring Card
                        _buildConsciousFrictionCard(colors)
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 24),

                        // Section 2: Session Limit Slider & Presets
                        _buildSessionThresholdSection(colors, timeLimit)
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 100.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 24),

                        // Section 3: Perimeter Apps
                        _buildPerimeterAppsSection(
                              colors,
                              apps,
                              enabledAppsCount,
                              usage?.appUsage ?? {},
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 24),

                        // Section 4: Pause Activity Protocol
                        _buildPauseProtocolSection(colors, interventionMode)
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 300.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 24),

                        // Section 5: Appearance / Theme Protocol
                        _buildThemeProtocolSection(colors, themeMode)
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 350.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 24),

                        // Section 6: Somatic Sensory Controls
                        _buildSomaticControlsSection(
                              colors,
                              hapticsEnabled,
                              soundsEnabled,
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 400.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 24),

                        // Section 7: System Sovereignty & Local Privacy
                        _buildSystemSovereigntySection(colors)
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 500.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TOP HEADER DECK
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeaderDeck(
    BuildContext context,
    SanctuaryColors colors,
    int enabledAppsCount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.headerBg,
        border: Border(bottom: BorderSide(color: colors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Sanctuary Settings',
                        style: AppTypography.titleMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary.withValues(
                                    alpha: 0.4 + (_pulseController.value * 0.5),
                                  ),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'SOVEREIGNTY DECK',
                    style: AppTypography.labelSmall.copyWith(
                      color: colors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Shielded Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  enabledAppsCount > 0 ? 'SHIELDED' : 'STANDBY',
                  style: AppTypography.labelSmall.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1: CONSCIOUS FRICTION CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildConsciousFrictionCard(SanctuaryColors colors) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.surfaceCard, colors.surfaceCardAlt],
        ),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: colors.isDark ? 0.4 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              // Conscious Friction Custom Ring
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(56, 56),
                      painter: _ConsciousFrictionRingPainter(
                        isDark: colors.isDark,
                        primary: colors.primary,
                      ),
                    ),
                    Icon(
                      Icons.hdr_strong_rounded,
                      color: colors.primary,
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'CONSCIOUS FRICTION ENGINE',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: AppTypography.labelSmall.copyWith(
                              color: colors.primary,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Mindful barrier armed',
                      style: AppTypography.titleSmall.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Micro-pauses intercepting dopaminergic compulsive reflex.',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Autonomous neural interception',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Latency 0.2s · Ready',
                  style: AppTypography.labelSmall.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2: SESSION LIMIT SLIDER & PRESETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSessionThresholdSection(
    SanctuaryColors colors,
    int currentLimit,
  ) {
    String getPresetLabel(int limit) {
      return switch (limit) {
        1 => '1 min Fast Zen',
        15 => '15 min Balanced',
        30 => '30 min Focus',
        45 => '45 min Deep',
        60 => '60 min Cap',
        _ => '$limit min Custom',
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.timer_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'SESSION THRESHOLD',
                  style: AppTypography.labelSmall.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Active: ${getPresetLabel(currentLimit)}',
                    style: AppTypography.labelSmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: colors.isDark ? 0.35 : 0.04,
                ),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continuous screen threshold:',
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      '${currentLimit}m',
                      style: AppTypography.labelSmall.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Slider
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: colors.primary,
                  inactiveTrackColor: colors.surfaceElevated,
                  thumbColor: colors.primary,
                  overlayColor: colors.primary.withValues(alpha: 0.18),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                    elevation: 3,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 18,
                  ),
                ),
                child: Slider(
                  value: currentLimit.toDouble().clamp(1.0, 60.0),
                  min: 1.0,
                  max: 60.0,
                  divisions: 59,
                  onChanged: (val) {
                    ref
                        .read(settingsProvider.notifier)
                        .setTimeLimit(val.round());
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1m Fast',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: colors.textTertiary,
                      ),
                    ),
                    Text(
                      '15m Balanced',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: colors.textTertiary,
                      ),
                    ),
                    Text(
                      '30m Focus',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: colors.textTertiary,
                      ),
                    ),
                    Text(
                      '60m Cap',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tactile Pill Presets
              _buildPresetsGrid(colors, currentLimit),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetsGrid(SanctuaryColors colors, int currentLimit) {
    final presets = [
      (1, '1 min Fast Zen', 'High friction intercept'),
      (15, '15 min Balanced', 'Recommended routine'),
      (30, '30 min Focus', 'Deep task flow'),
      (45, '45 min Deep', 'Extended immersion'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final item = presets[index];
        final limit = item.$1;
        final title = item.$2;
        final subtitle = item.$3;
        final isSelected = currentLimit == limit;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(settingsProvider.notifier).setTimeLimit(limit);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.15)
                  : colors.surfaceElevated.withValues(alpha: 0.6),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.6)
                    : colors.border,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.20),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? colors.textPrimary
                              : colors.textSecondary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: colors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 9.5,
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3: PERIMETER APPS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPerimeterAppsSection(
    SanctuaryColors colors,
    List<MonitoredApp> apps,
    int enabledCount,
    Map<String, int> appUsage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.security_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'PERIMETER APPS',
                  style: AppTypography.labelSmall.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                '$enabledCount of ${apps.length} Armed',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: colors.isDark ? 0.35 : 0.04,
                ),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apps.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: colors.border),
            itemBuilder: (context, index) {
              final app = apps[index];
              final minutes = appUsage[app.packageName] ?? 0;
              return _buildAppRow(colors, app, minutes);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppRow(
    SanctuaryColors colors,
    MonitoredApp app,
    int usageMinutes,
  ) {
    Color brandColor;
    IconData brandIcon;

    switch (app.name.toLowerCase()) {
      case 'youtube':
        brandColor = const Color(0xFFEF4444);
        brandIcon = Icons.smart_display_rounded;
        break;
      case 'instagram':
        brandColor = const Color(0xFFEC4899);
        brandIcon = Icons.photo_camera_rounded;
        break;
      case 'tiktok':
        brandColor = const Color(0xFF06B6D4);
        brandIcon = Icons.audiotrack_rounded;
        break;
      case 'facebook':
        brandColor = const Color(0xFF3B82F6);
        brandIcon = Icons.public_rounded;
        break;
      default:
        brandColor = colors.primary;
        brandIcon = Icons.apps_rounded;
    }

    final usageStr = usageMinutes >= 60
        ? '${usageMinutes ~/ 60}h ${usageMinutes % 60}m today'
        : '${usageMinutes}m today';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // App Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: brandColor.withValues(alpha: 0.25)),
            ),
            child: Icon(brandIcon, color: brandColor, size: 22),
          ),
          const SizedBox(width: 14),

          // Title + Subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      app.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: app.isEnabled
                            ? colors.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: app.isEnabled
                              ? colors.primary.withValues(alpha: 0.25)
                              : colors.border,
                        ),
                      ),
                      child: Text(
                        app.isEnabled ? 'ACTIVE GUARD' : 'STANDBY',
                        style: AppTypography.labelSmall.copyWith(
                          color: app.isEnabled
                              ? colors.primary
                              : colors.textTertiary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  app.isEnabled
                      ? 'Shielded · $usageStr'
                      : 'Not shielded · $usageStr',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Custom Glowing Switch
          _buildGlowingSwitch(
            colors: colors,
            value: app.isEnabled,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              ref
                  .read(settingsProvider.notifier)
                  .toggleApp(app.packageName, val);
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4: PAUSE ACTIVITY PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPauseProtocolSection(
    SanctuaryColors colors,
    InterventionMode currentMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.self_improvement_rounded,
              size: 16,
              color: colors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'PAUSE ACTIVITY PROTOCOL',
              style: AppTypography.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Controls which intentional practice appears during interception.',
          style: AppTypography.bodySmall.copyWith(
            color: colors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),

        // Option 1: Dhikr Only
        _buildActivityOption(
          colors: colors,
          mode: InterventionMode.dhikr,
          icon: Icons.psychology_rounded,
          title: 'Dhikr only',
          subtitle: 'Sacred remembrance & tasbih counter',
          isSelected: currentMode == InterventionMode.dhikr,
        ),

        const SizedBox(height: 8),

        // Option 2: Breathing Only
        _buildActivityOption(
          colors: colors,
          mode: InterventionMode.breathing,
          icon: Icons.air_rounded,
          title: 'Breathing only',
          subtitle: '4-7-8 parasympathetic calming cycle',
          isSelected: currentMode == InterventionMode.breathing,
        ),

        const SizedBox(height: 8),

        // Option 3: Both (Dhikr & Breathing) - Recommended
        _buildActivityOption(
          colors: colors,
          mode: InterventionMode.both,
          icon: Icons.auto_awesome_rounded,
          title: 'Both (Dhikr & Breathing)',
          subtitle: 'Recommended for mindful balance',
          badgeText: 'HARMONY',
          isSelected: currentMode == InterventionMode.both,
        ),
      ],
    );
  }

  Widget _buildActivityOption({
    required SanctuaryColors colors,
    required InterventionMode mode,
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(settingsProvider.notifier).setInterventionMode(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    colors.primary.withValues(alpha: 0.12),
                    colors.surfaceCard,
                  ],
                )
              : null,
          color: isSelected ? null : colors.surfaceCard.withValues(alpha: 0.8),
          border: Border.all(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.5)
                : colors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.18),
                    blurRadius: 14,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.20)
                    : colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colors.primary.withValues(alpha: 0.30)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? colors.primary : colors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleSmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (badgeText != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeText,
                            style: AppTypography.labelSmall.copyWith(
                              color: colors.onPrimary,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected ? colors.primary : colors.textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                  width: isSelected ? 2 : 1.5,
                ),
                color: isSelected ? colors.primary : Colors.transparent,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.onPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5: APPEARANCE / THEME PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildThemeProtocolSection(
    SanctuaryColors colors,
    ThemeMode currentMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.palette_rounded, size: 16, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'APPEARANCE & THEME',
              style: AppTypography.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Choose your mindful ambiance for the sanctuary.',
          style: AppTypography.bodySmall.copyWith(
            color: colors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildThemePill(
                colors: colors,
                title: 'Dark',
                icon: Icons.dark_mode_rounded,
                mode: ThemeMode.dark,
                isSelected: currentMode == ThemeMode.dark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildThemePill(
                colors: colors,
                title: 'Light',
                icon: Icons.light_mode_rounded,
                mode: ThemeMode.light,
                isSelected: currentMode == ThemeMode.light,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildThemePill(
                colors: colors,
                title: 'System',
                icon: Icons.brightness_auto_rounded,
                mode: ThemeMode.system,
                isSelected: currentMode == ThemeMode.system,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemePill({
    required SanctuaryColors colors,
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(settingsProvider.notifier).setThemeMode(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.15)
              : colors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.6)
                : colors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.18),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? colors.textPrimary : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6: SOMATIC SENSORY CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSomaticControlsSection(
    SanctuaryColors colors,
    bool hapticsEnabled,
    bool soundsEnabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.psychology_alt_rounded, size: 16, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'SOMATIC SENSORY CONTROLS',
              style: AppTypography.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: colors.isDark ? 0.35 : 0.04,
                ),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Haptic Feedback
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: hapticsEnabled
                            ? colors.primary.withValues(alpha: 0.15)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hapticsEnabled
                              ? colors.primary.withValues(alpha: 0.25)
                              : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.vibration_rounded,
                        color: hapticsEnabled
                            ? colors.primary
                            : colors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Haptic feedback',
                            style: AppTypography.titleSmall.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Subtle vibration on Dhikr count and breathing transitions',
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textSecondary,
                              fontSize: 11.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildGlowingSwitch(
                      colors: colors,
                      value: hapticsEnabled,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).toggleHaptics(val);
                      },
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: colors.border),

              // Calming Sounds
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: soundsEnabled
                            ? colors.primary.withValues(alpha: 0.15)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: soundsEnabled
                              ? colors.primary.withValues(alpha: 0.25)
                              : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: soundsEnabled
                            ? colors.primary
                            : colors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calming sounds',
                            style: AppTypography.titleSmall.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Gentle ambient nature audio during exercises',
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textSecondary,
                              fontSize: 11.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildGlowingSwitch(
                      colors: colors,
                      value: soundsEnabled,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).toggleSounds(val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7: SYSTEM SOVEREIGNTY & LOCAL PRIVACY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSystemSovereigntySection(SanctuaryColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user_rounded, size: 16, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'SYSTEM SOVEREIGNTY',
              style: AppTypography.labelSmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Protection Active Status Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: colors.isDark ? 0.35 : 0.04,
                ),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                          boxShadow: [
                            BoxShadow(color: colors.primary, blurRadius: 6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Protection Active',
                        style: AppTypography.titleSmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Validated',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceCardAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 18,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Usage & overlay permissions granted',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textPrimary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => context.push(Routes.permissions),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          'Manage',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Local Privacy Badge
        Center(
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Image.asset(
                    'assets/icon/logo.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ScrollGuard v${AppConstants.appVersion}',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'All activity data stays strictly on your device. Zero cloud tracking. Complete telemetry silence.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GLOWING CUSTOM SWITCH
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildGlowingSwitch({
    required SanctuaryColors colors,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? colors.primary : colors.surfaceElevated,
          boxShadow: value
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.45),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? colors.onPrimary : colors.surfaceCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.check_rounded,
                size: 13,
                color: value ? colors.primary : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONSCIOUS FRICTION RING PAINTER
// ═══════════════════════════════════════════════════════════════════════════

class _ConsciousFrictionRingPainter extends CustomPainter {
  final bool isDark;
  final Color primary;

  _ConsciousFrictionRingPainter({required this.isDark, required this.primary});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    // Track circle
    final trackPaint = Paint()
      ..color = isDark ? const Color(0xFF202328) : const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(Offset(cx, cy), r, trackPaint);

    // Active gradient arc
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final arcPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary,
          isDark ? const Color(0xFF005047) : const Color(0xFF14B8A6),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 1.4 * math.pi, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _ConsciousFrictionRingPainter oldDelegate) =>
      oldDelegate.isDark != isDark || oldDelegate.primary != primary;
}
