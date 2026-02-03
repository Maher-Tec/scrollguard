import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';
import '../widgets/daily_progress.dart';
import '../widgets/quick_stats.dart';
import '../../../data/models/user_settings.dart';
import '../../../data/models/usage_entry.dart';
import '../../../data/models/monitored_app.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _breatheController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Refresh usage on initial load to ensure we have latest data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usageProvider.notifier).reload();
    });
    
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _breatheController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh usage data when app comes to foreground
      ref.read(usageProvider.notifier).reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final usage = ref.watch(usageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ═══════════════════════════════════════════════════════════════
            // APP BAR
            // ═══════════════════════════════════════════════════════════════
            
            SliverToBoxAdapter(
              child: _buildAppBar(),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // CONTENT
            // ═══════════════════════════════════════════════════════════════
            
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  
                  // Hero Stats Card
                  _buildHeroCard(settings, usage)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Quick Stats Row
                  QuickStatsRow(usage: usage)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Daily Progress
                  DailyProgressCard(settings: settings, usage: usage)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Monitored Apps
                  _buildMonitoredAppsSection(settings)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════════════
      // FLOATING ACTION BUTTON
      // ═══════════════════════════════════════════════════════════════════
      
      floatingActionButton: _buildFAB(settings),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'ScrollGuard',
                style: AppTypography.headlineMedium,
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: IconButton(
              onPressed: () => context.push(Routes.settings),
              icon: const Icon(Icons.settings_rounded),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 400.ms);
  }

  Widget _buildHeroCard(
    AsyncValue<UserSettings> settings,
    AsyncValue<DailyUsage> usage,
  ) {
    final usageData = usage.valueOrNull;
    final totalMinutes = usageData?.totalMinutes ?? 0;
    
    // Get limit from settings, default to 60 if null
    final int limit = settings.valueOrNull?.timeLimitMinutes ?? 60;
    
    // Calculate progress (clamp to 0.0 - 1.0)
    final double progress = (limit > 0) 
        ? (totalMinutes / limit).clamp(0.0, 1.0) 
        : 0.0;

    // Determine color/gradient based on usage
    LinearGradient progressGradient;
    Color glowColor;
    
    if (progress < 0.6) {
      progressGradient = AppColors.primaryGradient;
      glowColor = AppColors.primary;
    } else if (progress < 0.9) {
      // Amber/Orange for warning zone
      progressGradient = const LinearGradient(
        colors: [AppColors.warningLight, AppColors.warning],
      );
      glowColor = AppColors.warning;
    } else {
      // Red for danger zone
      progressGradient = const LinearGradient(
        colors: [AppColors.errorLight, AppColors.error],
      );
      glowColor = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ═════════════════════════════════════════════════════════════════
          // CIRCULAR PROGRESS TIMER
          // ═════════════════════════════════════════════════════════════════
          
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Pulsing Glow (Behind)
                AnimatedBuilder(
                  animation: _breatheController, // Reusing existing controller
                  builder: (context, child) {
                    final scale = 0.95 + (_breatheController.value * 0.1); // 0.95 -> 1.05
                    final opacity = 0.2 + (_breatheController.value * 0.3); // 0.2 -> 0.5
                    
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(opacity * 0.6), // Dimmer glow
                              blurRadius: 50,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // 2. Background Ring/Track
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: 1.0, // Full circle
                    strokeWidth: 18,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.surfaceLight, // Subtle dark track
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),

                // 3. Gradient Progress Indicator (Foreground)
                SizedBox(
                  width: 220,
                  height: 220,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return progressGradient.createShader(rect);
                    },
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 18,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), // Color ignored by ShaderMask, but needed
                      backgroundColor: Colors.transparent,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),

                // 4. Center Text Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${totalMinutes}m',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 48, 
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container( // Limit Badge
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Text(
                        'of ${limit}m limit',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // ═════════════════════════════════════════════════════════════════
          // TEXT LABELS
          // ═════════════════════════════════════════════════════════════════
          
          Text(
            'Today\'s Social Media Time',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _getMotivationalMessage(totalMinutes),
              key: ValueKey<String>(_getMotivationalMessage(totalMinutes)),
              style: AppTypography.bodyMedium.copyWith(
                color: glowColor, // Tint text with status color
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitoredAppsSection(AsyncValue<UserSettings> settings) {
    final settingsData = settings.valueOrNull;
    // Explicitly type the empty list to prevent List<dynamic> inference
    final enabledApps = settingsData?.enabledApps ?? <MonitoredApp>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monitored Apps',
              style: AppTypography.titleLarge,
            ),
            TextButton(
              onPressed: () => context.push(Routes.settings),
              child: Text(
                'Edit',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (enabledApps.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'No apps being monitored',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: enabledApps.map((app) => _buildAppChip(app.name)).toList(),
          ),
      ],
    );
  }

  Widget _buildAppChip(String name) {
    Color color;
    IconData icon;
    
    switch (name) {
      case 'Instagram':
        color = AppColors.instagram;
        icon = Icons.camera_alt_rounded;
        break;
      case 'TikTok':
        color = AppColors.tiktok;
        icon = Icons.music_note_rounded;
        break;
      case 'YouTube':
        color = AppColors.youtube;
        icon = Icons.play_circle_filled_rounded;
        break;
      case 'Facebook':
        color = AppColors.facebook;
        icon = Icons.facebook_rounded;
        break;
      default:
        color = AppColors.primary;
        icon = Icons.apps_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            name,
            style: AppTypography.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(AsyncValue<UserSettings> settings) {
    final settingsData = settings.valueOrNull;
    final isActive = settingsData?.monitoringActive ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () async {
          HapticFeedback.mediumImpact();
          final newActiveStatus = !isActive;
          await ref.read(settingsProvider.notifier).toggleMonitoring(newActiveStatus);
          
          if (newActiveStatus) {
            // Reset the session baseline so tracking starts from current time
            await ref.read(usageProvider.notifier).startSession();
          } else {
            // Optional: Clear baseline when turning off if you want 
            // the next "Start" to be a fresh start.
            // But startSession() already snapshots the current usage.
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.primaryGradient : null,
            color: isActive ? null : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isActive 
                  ? Colors.transparent 
                  : AppColors.glassBorder,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive 
                    ? Icons.shield_rounded 
                    : Icons.shield_outlined,
                color: isActive 
                    ? AppColors.textOnPrimary 
                    : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                isActive ? 'Protection Active' : 'Start Protection',
                style: AppTypography.labelLarge.copyWith(
                  color: isActive 
                      ? AppColors.textOnPrimary 
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 500.ms, delay: 400.ms)
    .slideY(begin: 0.5, end: 0);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }



  String _getMotivationalMessage(int minutes) {
    if (minutes == 0) return 'Start your day mindfully ✨';
    if (minutes < 15) return 'Great start! Keep it mindful 🌱';
    if (minutes < 30) return 'You\'re doing well today 💚';
    if (minutes < 45) return 'Consider a mindful break 🧘';
    return 'Time for some fresh air? 🌿';
  }
}
