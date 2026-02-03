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
import '../../../router.dart';

class AppSelectionScreen extends ConsumerStatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  ConsumerState<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends ConsumerState<AppSelectionScreen> {
  int _selectedTimeLimit = AppConstants.defaultTimeLimit;
  final Set<String> _selectedApps = {};

  @override
  void initState() {
    super.initState();
    // Pre-select all apps by default
    for (final app in DefaultApps.all) {
      _selectedApps.add(app.packageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════════════════════════════════════════════════
            // HEADER
            // ═══════════════════════════════════════════════════════════════
            
            _buildHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    
                    // ═══════════════════════════════════════════════════════════
                    // APP SELECTION
                    // ═══════════════════════════════════════════════════════════
                    
                    Text(
                      'Select Apps to Monitor',
                      style: AppTypography.headlineSmall,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'We\'ll gently remind you when you\'ve been scrolling too long',
                      style: AppTypography.bodyMedium,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms),
                    
                    const SizedBox(height: 24),
                    
                    _buildAppGrid(),
                    
                    const SizedBox(height: 40),
                    
                    // ═══════════════════════════════════════════════════════════
                    // TIME LIMIT
                    // ═══════════════════════════════════════════════════════════
                    
                    Text(
                      'Daily Time Limit',
                      style: AppTypography.headlineSmall,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideX(begin: -0.1, end: 0),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'After this time, we\'ll invite you to take a mindful break',
                      style: AppTypography.bodyMedium,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms),
                    
                    const SizedBox(height: 24),
                    
                    _buildTimeSelector(),
                    
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // CONTINUE BUTTON
            // ═══════════════════════════════════════════════════════════════
            
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textSecondary,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Step 1 of 2',
              style: AppTypography.labelMedium,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAppGrid() {
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
        
        return _buildAppCard(app, isSelected, index);
      },
    );
  }

  Widget _buildAppCard(MonitoredApp app, bool isSelected, int index) {
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
        appColor = AppColors.primary;
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
              ? appColor.withOpacity(0.15) 
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? appColor.withOpacity(0.5) 
                : AppColors.glassBorder,
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
                color: appColor.withOpacity(0.2),
              ),
              child: Icon(
                appIcon,
                color: appColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              app.name,
              style: AppTypography.titleSmall.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
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

  Widget _buildTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_selectedTimeLimit',
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
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AppConstants.timePresets.map((minutes) {
                final isSelected = _selectedTimeLimit == minutes;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedTimeLimit = minutes;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primary.withOpacity(0.2) 
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.primary 
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${minutes}m',
                          style: AppTypography.labelLarge.copyWith(
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
    )
    .animate()
    .fadeIn(duration: 400.ms, delay: 400.ms)
    .slideY(begin: 0.1, end: 0);
  }

  Widget _buildContinueButton() {
    final hasSelection = _selectedApps.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider.withOpacity(0.5)),
        ),
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
                  ? AppColors.primaryGradient 
                  : null,
              color: hasSelection ? null : AppColors.surfaceLight,
              boxShadow: hasSelection ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ] : null,
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
                'Continue',
                style: AppTypography.labelLarge.copyWith(
                  color: hasSelection 
                      ? AppColors.textOnPrimary 
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onContinue() async {
    // Update settings with selected apps
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final currentSettings = ref.read(settingsProvider).valueOrNull;
    
    if (currentSettings != null) {
      final updatedApps = currentSettings.monitoredApps.map((app) {
        return app.copyWith(
          isEnabled: _selectedApps.contains(app.packageName),
        );
      }).toList();
      
      await settingsNotifier.updateSettings(
        currentSettings.copyWith(
          monitoredApps: updatedApps,
          timeLimitMinutes: _selectedTimeLimit,
        ),
      );
    }
    
    if (mounted) {
      context.push(Routes.permissions);
    }
  }
}
