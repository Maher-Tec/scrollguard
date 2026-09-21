import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/social_platform_logo.dart';
import '../../../data/models/monitored_app.dart';
import '../../../data/models/usage_entry.dart';
import '../../../data/models/user_settings.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';
import '../widgets/mindful_practices_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _breatheController;
  late AnimationController _pulseController;
  bool _serviceReady = false;
  bool _changingProtection = false;

  Future<void> _refreshProtection() async {
    await ref.read(usageProvider.notifier).reload();
    await ref.read(dhikrCountProvider.notifier).loadTodayCount();
    final ready = await ref
        .read(usageStatsServiceProvider)
        .isMonitoringActive();
    if (mounted) {
      setState(() {
        _serviceReady = ready;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProtection();
    });

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _breatheController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProtection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sanctuary;
    final settings = ref.watch(settingsProvider);
    final usage = ref.watch(usageProvider);

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
          child: _buildSystemShieldBar(context, settings),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ═══════════════════════════════════════════════════════════════
            // APP BAR (Clean & Minimal)
            // ═══════════════════════════════════════════════════════════════
            SliverToBoxAdapter(child: _buildAppBar(context)),

            // ═══════════════════════════════════════════════════════════════
            // DASHBOARD CONTENT
            // ═══════════════════════════════════════════════════════════════
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Current session
                  _buildHeroCard(context, settings, usage)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 16),

                  // Pause actions
                  const MindfulPracticesSection()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 140.ms)
                      .slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 18),

                  // Monitored apps
                  _buildMonitoredAppsSection(context, settings, usage)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 260.ms)
                      .slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colors = context.sanctuary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
      child: Row(
        children: [
          Image.asset(
            'assets/icon/logo.png',
            width: 34,
            height: 34,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'ScrollGuard',
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      fontSize: 18,
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
                          color: colors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(
                                alpha: 0.5 + (_pulseController.value * 0.5),
                              ),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text(
                'DIGITAL SANCTUARY',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.primary.withValues(alpha: 0.85),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Sanctuary Settings Button (Single, clean button)
          IconButton(
            onPressed: () => context.push(Routes.settings),
            icon: const Icon(Icons.tune_rounded),
            color: colors.textSecondary,
            tooltip: 'Sanctuary Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    AsyncValue<UserSettings> settings,
    AsyncValue<DailyUsage> usage,
  ) {
    final colors = context.sanctuary;
    final usageData = usage.valueOrNull;
    final totalMinutes = usageData?.totalMinutes ?? 0;
    final settingsData = settings.valueOrNull;
    final int limit = settingsData?.timeLimitMinutes ?? 60;
    final double progress = (limit > 0)
        ? (totalMinutes / limit).clamp(0.0, 1.0)
        : 0.0;
    final int remaining = (limit - totalMinutes).clamp(0, limit);
    final isProtectionActive =
        (settingsData?.monitoringActive ?? false) && _serviceReady;
    final hasPassedLimit = totalMinutes >= limit && limit > 0;
    final isLimitReached = isProtectionActive && hasPassedLimit;

    final Color glowColor = !isProtectionActive
        ? colors.gold
        : isLimitReached
        ? colors.coralGlow
        : colors.primary;
    final List<Color> gaugeColors = !isProtectionActive
        ? [colors.gold, AppColors.warning]
        : isLimitReached
        ? [colors.coralGlow, colors.coralDark]
        : [colors.primary, colors.primaryContainer];

    final enabledApps = settingsData?.enabledApps ?? <MonitoredApp>[];
    final isMultipleApps = enabledApps.length > 1;
    final String targetAppName = isMultipleApps
        ? 'Monitored apps'
        : enabledApps.isNotEmpty
        ? enabledApps.first.name
        : 'No apps selected';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: !isProtectionActive
              ? colors.gold.withValues(alpha: 0.28)
              : isLimitReached
              ? colors.coralGlow.withValues(alpha: 0.3)
              : colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(
              alpha: isLimitReached ? 0.12 : (colors.isDark ? 0.05 : 0.08),
            ),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: colors.isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Target App Header + Status Pill (Clean & Flexible)
          Row(
            children: [
              if (enabledApps.isNotEmpty)
                _heroAppMark(enabledApps)
              else
                Icon(Icons.apps_rounded, color: glowColor, size: 38),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      targetAppName,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontSize: 17,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      isProtectionActive
                          ? (isMultipleApps
                                ? '${enabledApps.length} apps in this session'
                                : 'Current session')
                          : "Today's device activity",
                      style: AppTypography.labelSmall.copyWith(
                        color: colors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Glowing Neon Status Pill (Overflow-proof)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: glowColor.withValues(
                    alpha: colors.isDark ? 0.12 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: glowColor.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: glowColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      !isProtectionActive
                          ? 'Protection off'
                          : isLimitReached
                          ? 'Limit reached'
                          : '$remaining min left',
                      style: AppTypography.labelSmall.copyWith(
                        color: !isProtectionActive
                            ? colors.gold
                            : isLimitReached
                            ? (colors.isDark
                                  ? AppColors.tertiaryFixedDim
                                  : colors.coralGlow)
                            : colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ═════════════════════════════════════════════════════════════════
          // CIRCULAR PROGRESS GAUGE
          // ═════════════════════════════════════════════════════════════════
          SizedBox(
            width: 184,
            height: 184,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Ambient Drop Shadow
                Container(
                  width: 178,
                  height: 178,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(
                          alpha: colors.isDark ? 0.3 : 0.15,
                        ),
                        blurRadius: 26,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // 2. Custom Painted Gauge Arc
                SizedBox(
                  width: 178,
                  height: 178,
                  child: CustomPaint(
                    painter: _GradientArcPainter(
                      progress: isLimitReached
                          ? 1.0
                          : (progress > 0 ? progress : 0.04),
                      trackColor: colors.isDark
                          ? const Color(0xFF1C222C)
                          : const Color(0xFFE2E8F0),
                      gradientColors: gaugeColors,
                      strokeWidth: 8,
                    ),
                  ),
                ),

                // 3. Inner Dial Disc
                Container(
                  width: 146,
                  height: 146,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: colors.isDark
                          ? const [Color(0xFF141820), Color(0xFF0D1017)]
                          : const [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
                    ),
                    border: Border.all(color: colors.border, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: colors.isDark
                            ? Colors.black.withValues(alpha: 0.7)
                            : const Color(0xFF0F172A).withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isMultipleApps && enabledApps.isNotEmpty) ...[
                        SocialPlatformLogo(name: targetAppName, size: 22),
                        const SizedBox(height: 5),
                      ],
                      Text(
                        '$totalMinutes',
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                          color: colors.textPrimary,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isProtectionActive ? 'minutes used' : 'minutes today',
                        style: AppTypography.labelSmall.copyWith(
                          color: !isProtectionActive
                              ? colors.gold
                              : isLimitReached
                              ? (colors.isDark
                                    ? AppColors.tertiaryFixedDim
                                    : colors.coralGlow)
                              : colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isProtectionActive
                            ? 'of $limit min'
                            : 'before protection',
                        style: AppTypography.labelSmall.copyWith(
                          color: colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // A short budget summary below the timer.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      isProtectionActive
                          ? '$limit min session limit'
                          : '$limit min limit when protected',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (isProtectionActive)
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: glowColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${(progress * 100).toInt()}% used',
                        style: AppTypography.labelSmall.copyWith(
                          color: glowColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          if (!isProtectionActive || isLimitReached) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: glowColor.withValues(alpha: colors.isDark ? 0.08 : 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: glowColor.withValues(
                    alpha: colors.isDark ? 0.2 : 0.25,
                  ),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    !isProtectionActive
                        ? Icons.shield_outlined
                        : isLimitReached
                        ? Icons.hourglass_top_rounded
                        : Icons.spa_rounded,
                    color: glowColor,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textPrimary.withValues(alpha: 0.9),
                          fontSize: 12,
                          height: 1.35,
                        ),
                        children: [
                          TextSpan(
                            text: !isProtectionActive
                                ? enabledApps.isEmpty
                                      ? 'Choose apps to monitor. '
                                      : 'Today: $totalMinutes min ${isMultipleApps ? 'across monitored apps' : 'on $targetAppName'}. '
                                : isLimitReached
                                ? 'Gentle pause active '
                                : 'Conscious scrolling active ',
                            style: TextStyle(
                              color: glowColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: !isProtectionActive
                                ? 'Start protection for a fresh session and a pause at $limit min.'
                                : isLimitReached
                                ? '· Take a soothing breath before deciding to resume.'
                                : '· Take mindful pauses between your sessions.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _heroAppMark(List<MonitoredApp> apps) {
    if (apps.length == 1) {
      return SocialPlatformLogo(name: apps.first.name, size: 38);
    }
    return SizedBox(
      width: 52,
      height: 38,
      child: Stack(
        children: [
          SocialPlatformLogo(name: apps.first.name, size: 38),
          Positioned(
            right: 0,
            bottom: 0,
            child: SocialPlatformLogo(name: apps[1].name, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitoredAppsSection(
    BuildContext context,
    AsyncValue<UserSettings> settings,
    AsyncValue<DailyUsage> usage,
  ) {
    final colors = context.sanctuary;
    final settingsData = settings.valueOrNull;
    final enabledApps = settingsData?.enabledApps ?? <MonitoredApp>[];
    final defaultAppNames = ['YouTube', 'Instagram', 'TikTok', 'Facebook'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Monitored apps',
                  style: AppTypography.titleMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.push(Routes.settings),
              child: Text(
                'Manage',
                style: AppTypography.labelMedium.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: defaultAppNames.map((name) {
            final isTarget = enabledApps.any(
              (app) => app.name.toLowerCase() == name.toLowerCase(),
            );
            return _buildAppPill(context, name, isActive: isTarget);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppPill(
    BuildContext context,
    String name, {
    required bool isActive,
  }) {
    final colors = context.sanctuary;

    return Container(
      padding: const EdgeInsets.fromLTRB(7, 5, 12, 5),
      decoration: BoxDecoration(
        color: isActive
            ? colors.primary.withValues(alpha: colors.isDark ? 0.12 : 0.08)
            : colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? colors.primary.withValues(alpha: colors.isDark ? 0.35 : 0.3)
              : colors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SocialPlatformLogo(name: name, size: 24),
          const SizedBox(width: 8),
          Text(
            name,
            style: AppTypography.labelSmall.copyWith(
              color: isActive ? colors.primary : colors.textSecondary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
          if (isActive) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: colors.primary.withValues(
                  alpha: colors.isDark ? 0.2 : 0.15,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Active',
                style: AppTypography.labelSmall.copyWith(
                  color: colors.isDark ? Colors.white : colors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemShieldBar(
    BuildContext context,
    AsyncValue<UserSettings> settings,
  ) {
    final colors = context.sanctuary;
    final settingsData = settings.valueOrNull;
    final isActive = (settingsData?.monitoringActive ?? false) && _serviceReady;

    return GestureDetector(
      onTap: () async {
        if (_changingProtection || settingsData == null) return;
        setState(() => _changingProtection = true);
        try {
          HapticFeedback.mediumImpact();
          if (isActive) {
            await ref.read(settingsProvider.notifier).toggleMonitoring(false);
            if (mounted) setState(() => _serviceReady = false);
            return;
          }

          final permissions = await ref
              .read(permissionServiceProvider)
              .getPermissionStatus();
          if (!permissions.allGranted) {
            if (context.mounted) context.push(Routes.permissions);
            return;
          }

          await ref.read(usageProvider.notifier).startSession();
          final started = await ref
              .read(usageStatsServiceProvider)
              .startMonitoring(
                packageNames: settingsData.enabledPackages,
                timeLimitMinutes: settingsData.timeLimitMinutes,
                baselines: {
                  for (final packageName in settingsData.enabledPackages)
                    packageName: 0,
                },
              );
          if (started) {
            await ref.read(settingsProvider.notifier).toggleMonitoring(true);
            await _refreshProtection();
          }
        } finally {
          if (mounted) setState(() => _changingProtection = false);
        }
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    colors.primary.withValues(
                      alpha: colors.isDark ? 0.20 : 0.12,
                    ),
                    colors.surfaceCard,
                  ],
                )
              : LinearGradient(
                  colors: [
                    colors.primary,
                    colors.isDark
                        ? const Color(0xFF47CDBB)
                        : const Color(0xFF0F766E),
                  ],
                ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive
                ? colors.primary.withValues(alpha: 0.45)
                : colors.primary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (isActive ? colors.primary : const Color(0xFF42D7C4))
                  .withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive
                    ? colors.primary.withValues(alpha: 0.10)
                    : colors.surface.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/icon/logo.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isActive ? 'Protection active' : 'Start protection',
              style: AppTypography.labelMedium.copyWith(
                color: isActive ? colors.textPrimary : Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (_changingProtection)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isActive ? colors.primary : Colors.white,
                ),
              )
            else
              Icon(
                isActive
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,
                color: isActive ? colors.primary : Colors.white,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws a circular progress arc with a smooth sweep gradient,
/// eliminating any square bounding box artifacts.
class _GradientArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final List<Color> gradientColors;
  final double strokeWidth;

  _GradientArcPainter({
    required this.progress,
    required this.trackColor,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw background track (full circle)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw progress arc with SweepGradient
    const startAngle = -math.pi / 2;
    final sweepAngle = (2 * math.pi * progress).clamp(0.0, 2 * math.pi);

    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: gradientColors,
      transform: const GradientRotation(-math.pi / 2),
    );

    final arcPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _GradientArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors;
  }
}
