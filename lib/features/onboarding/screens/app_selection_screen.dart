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

class AppSelectionScreen extends ConsumerStatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  ConsumerState<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends ConsumerState<AppSelectionScreen> {
  int _currentStep = 1;
  int _selectedTimeLimit = AppConstants.defaultTimeLimit;
  final Set<String> _selectedApps = {};
  InterventionMode _selectedInterventionMode = InterventionMode.both;
  ThemeMode _selectedThemeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    for (final app in DefaultApps.all) {
      _selectedApps.add(app.packageName);
    }
    final savedSettings = ref.read(settingsProvider).valueOrNull;
    if (savedSettings != null) {
      _selectedTimeLimit = savedSettings.timeLimitMinutes;
      _selectedInterventionMode = savedSettings.interventionMode;
      _selectedThemeMode = savedSettings.themeMode == ThemeMode.light
          ? ThemeMode.light
          : ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sanctuary;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    if (_currentStep == 1) ...[
                      Text(
                            'Select Apps to Monitor',
                            style: AppTypography.headlineSmall.copyWith(
                              color: colors.textPrimary,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ll gently remind you when you\'ve been scrolling too long',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      const SizedBox(height: 24),
                      _buildAppGrid(context),
                      const SizedBox(height: 40),
                      Text(
                            'Session Time Limit',
                            style: AppTypography.headlineSmall.copyWith(
                              color: colors.textPrimary,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        'After this time, we\'ll invite you to take a mindful break',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                      const SizedBox(height: 24),
                      _buildTimeSelector(context),
                      const SizedBox(height: 80),
                    ] else ...[
                      _buildPreferencesStep(context),
                      const SizedBox(height: 80),
                    ],
                  ],
                ),
              ),
            ),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.sanctuary;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_currentStep == 2) {
                setState(() => _currentStep = 1);
              } else {
                context.pop();
              }
            },
            icon: const Icon(Icons.arrow_back_rounded),
            color: colors.textSecondary,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              'Step $_currentStep of 2',
              style: AppTypography.labelMedium.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAppGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: DefaultApps.all.length,
      itemBuilder: (context, index) {
        final app = DefaultApps.all[index];
        final isSelected = _selectedApps.contains(app.packageName);
        return _buildAppCard(context, app, isSelected, index);
      },
    );
  }

  Widget _buildAppCard(
    BuildContext context,
    MonitoredApp app,
    bool isSelected,
    int index,
  ) {
    final colors = context.sanctuary;
    Color appColor;
    IconData appIcon;

    switch (app.name) {
      case 'Instagram':
        appColor = AppColors.instagram;
        appIcon = Icons.camera_alt_rounded;
        break;
      case 'TikTok':
        appColor = AppColors.tiktok;
        appIcon = Icons.music_note_rounded;
        break;
      case 'YouTube':
        appColor = AppColors.youtube;
        appIcon = Icons.play_circle_filled_rounded;
        break;
      case 'Facebook':
        appColor = AppColors.facebook;
        appIcon = Icons.facebook_rounded;
        break;
      default:
        appColor = colors.primary;
        appIcon = Icons.apps_rounded;
    }

    return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              if (isSelected) {
                _selectedApps.remove(app.packageName);
              } else {
                _selectedApps.add(app.packageName);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? appColor.withValues(alpha: colors.isDark ? 0.15 : 0.10)
                  : colors.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? appColor.withValues(alpha: colors.isDark ? 0.5 : 0.6)
                    : colors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColor.withValues(alpha: 0.2),
                  ),
                  child: Icon(appIcon, color: appColor, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  app.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: isSelected
                        ? colors.textPrimary
                        : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (100 + index * 100).ms)
        .scaleXY(begin: 0.9, end: 1.0, curve: Curves.easeOutBack);
  }

  Widget _buildTimeSelector(BuildContext context) {
    final colors = context.sanctuary;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_selectedTimeLimit',
                    style: AppTypography.statValue.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'minutes',
                    style: AppTypography.bodyLarge.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: AppConstants.timePresets.map((minutes) {
                  final isSelected = _selectedTimeLimit == minutes;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedTimeLimit = minutes;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.primary.withValues(
                                    alpha: colors.isDark ? 0.2 : 0.12,
                                  )
                                : (colors.isDark
                                      ? AppColors.surfaceLight
                                      : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colors.primary
                                  : colors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${minutes}m',
                              maxLines: 1,
                              style: AppTypography.labelLarge.copyWith(
                                color: isSelected
                                    ? colors.primary
                                    : colors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildContinueButton(BuildContext context) {
    final colors = context.sanctuary;
    final hasSelection = _selectedApps.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        children: [
          if (!hasSelection)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Select at least one app to continue',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: hasSelection
                  ? LinearGradient(
                      colors: [
                        colors.primary,
                        colors.isDark
                            ? const Color(0xFF47CDBB)
                            : const Color(0xFF0F766E),
                      ],
                    )
                  : null,
              color: hasSelection
                  ? null
                  : (colors.isDark
                        ? AppColors.surfaceLight
                        : const Color(0xFFE2E8F0)),
              boxShadow: hasSelection
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: hasSelection ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                _currentStep == 1 ? 'Continue' : 'Finish setup',
                style: AppTypography.labelLarge.copyWith(
                  color: hasSelection
                      ? (colors.isDark ? AppColors.textOnPrimary : Colors.white)
                      : colors.textTertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep(BuildContext context) {
    final colors = context.sanctuary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your mindful pause',
          style: AppTypography.headlineSmall.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What helps you slow down and return with intention?',
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        _buildPreferenceOption(
          context,
          icon: Icons.menu_book_rounded,
          title: 'Dhikr',
          subtitle: 'A short moment of remembrance',
          selected: _selectedInterventionMode == InterventionMode.dhikr,
          onTap: () => setState(
            () => _selectedInterventionMode = InterventionMode.dhikr,
          ),
        ),
        const SizedBox(height: 10),
        _buildPreferenceOption(
          context,
          icon: Icons.air_rounded,
          title: 'Breathing',
          subtitle: 'A guided exercise to settle your attention',
          selected: _selectedInterventionMode == InterventionMode.breathing,
          onTap: () => setState(
            () => _selectedInterventionMode = InterventionMode.breathing,
          ),
        ),
        const SizedBox(height: 10),
        _buildPreferenceOption(
          context,
          icon: Icons.auto_awesome_rounded,
          title: 'Both',
          subtitle: 'Choose Dhikr or breathing at each pause',
          badge: 'Recommended',
          selected: _selectedInterventionMode == InterventionMode.both,
          onTap: () =>
              setState(() => _selectedInterventionMode = InterventionMode.both),
        ),
        const SizedBox(height: 32),
        Text(
          'Appearance',
          style: AppTypography.headlineSmall.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pick the display that feels most comfortable.',
          style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildThemeOption(
                context,
                icon: Icons.dark_mode_rounded,
                label: 'Dark',
                selected: _selectedThemeMode == ThemeMode.dark,
                onTap: () {
                  setState(() => _selectedThemeMode = ThemeMode.dark);
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeOption(
                context,
                icon: Icons.light_mode_rounded,
                label: 'Light',
                selected: _selectedThemeMode == ThemeMode.light,
                onTap: () {
                  setState(() => _selectedThemeMode = ThemeMode.light);
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferenceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
    String? badge,
  }) {
    final colors = context.sanctuary;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: colors.isDark ? 0.12 : 0.08)
              : colors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: colors.primary, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleSmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            badge,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: colors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colors.primary : colors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = context.sanctuary;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 84,
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: colors.isDark ? 0.12 : 0.08)
              : colors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? colors.primary : colors.textSecondary),
            const SizedBox(height: 7),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: colors.textPrimary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_currentStep == 1) {
      HapticFeedback.selectionClick();
      setState(() => _currentStep = 2);
      return;
    }

    final settingsNotifier = ref.read(settingsProvider.notifier);
    final currentSettings = ref.read(settingsProvider).valueOrNull;

    if (currentSettings != null) {
      final updatedApps = currentSettings.monitoredApps.map((app) {
        return app.copyWith(isEnabled: _selectedApps.contains(app.packageName));
      }).toList();

      await settingsNotifier.updateSettings(
        currentSettings.copyWith(
          monitoredApps: updatedApps,
          timeLimitMinutes: _selectedTimeLimit,
          interventionMode: _selectedInterventionMode,
          themeMode: _selectedThemeMode,
        ),
      );
    }

    if (mounted) {
      context.push(Routes.permissions);
    }
  }
}
