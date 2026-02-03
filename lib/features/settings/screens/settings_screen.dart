import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/monitored_app.dart';
import '../../../providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsData = settings.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
          color: AppColors.textSecondary,
        ),
        title: Text(
          'Settings',
          style: AppTypography.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ═══════════════════════════════════════════════════════════════
            // TIME LIMIT SECTION
            // ═══════════════════════════════════════════════════════════════
            
            _buildSectionHeader('Time Limit', Icons.timer_outlined)
            .animate()
            .fadeIn(duration: 400.ms),
            
            const SizedBox(height: 16),
            
            _buildTimeLimitSelector(settingsData?.timeLimitMinutes ?? 30)
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms),
            
            const SizedBox(height: 32),
            
            // ═══════════════════════════════════════════════════════════════
            // MONITORED APPS SECTION
            // ═══════════════════════════════════════════════════════════════
            
            _buildSectionHeader('Monitored Apps', Icons.apps_rounded)
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms),
            
            const SizedBox(height: 16),
            
            _buildAppsGrid(settingsData?.monitoredApps ?? [])
            .animate()
            .fadeIn(duration: 400.ms, delay: 300.ms),
            
            const SizedBox(height: 8),
            
            // ═══════════════════════════════════════════════════════════════
            // EXPERIENCE SECTION
            // ═══════════════════════════════════════════════════════════════
            
            _buildSectionHeader('Experience', Icons.tune_rounded)
            .animate()
            .fadeIn(duration: 400.ms, delay: 400.ms),
            
            const SizedBox(height: 16),
            
            _buildToggleTile(
              icon: Icons.vibration_rounded,
              title: 'Haptic Feedback',
              subtitle: 'Gentle vibrations during breathing',
              value: settingsData?.hapticsEnabled ?? true,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleHaptics(value);
              },
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 500.ms),
            
            const SizedBox(height: 12),
            
            _buildToggleTile(
              icon: Icons.volume_up_rounded,
              title: 'Calming Sounds',
              subtitle: 'Ambient tones during exercises',
              value: settingsData?.soundsEnabled ?? true,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleSounds(value);
              },
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 600.ms),
            
            const SizedBox(height: 32),
            
            // ═══════════════════════════════════════════════════════════════
            // ABOUT SECTION
            // ═══════════════════════════════════════════════════════════════
            
            _buildSectionHeader('About', Icons.info_outline_rounded)
            .animate()
            .fadeIn(duration: 400.ms, delay: 700.ms),
            
            const SizedBox(height: 16),
            
            _buildInfoCard()
            .animate()
            .fadeIn(duration: 400.ms, delay: 800.ms),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textTertiary, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLimitSelector(int currentLimit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$currentLimit',
                style: AppTypography.statValue.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'minutes',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AppConstants.timePresets.map((minutes) {
                final isSelected = currentLimit == minutes;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(settingsProvider.notifier).setTimeLimit(minutes);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primary.withOpacity(0.2) 
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.primary 
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${minutes}m',
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected 
                                ? AppColors.primary 
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppsGrid(List<MonitoredApp> apps) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.0,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return _buildAppTile(app);
      },
    );
  }

  Widget _buildAppTile(MonitoredApp app) {
    Color color;
    IconData icon;
    
    switch (app.name) {
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

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(settingsProvider.notifier).toggleApp(
          app.packageName, 
          !app.isEnabled,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: app.isEnabled 
              ? color.withOpacity(0.15) 
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: app.isEnabled 
                ? color.withOpacity(0.4) 
                : AppColors.glassBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  app.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: app.isEnabled 
                        ? AppColors.textPrimary 
                        : AppColors.textTertiary,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              app.isEnabled 
                  ? Icons.check_circle_rounded 
                  : Icons.radio_button_unchecked_rounded,
              color: app.isEnabled ? color : AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppColors.textOnPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ScrollGuard',
                    style: AppTypography.titleMedium,
                  ),
                  Text(
                    'Version ${AppConstants.appVersion}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.appTagline,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.success,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All data stays on your device',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.success,
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
}
