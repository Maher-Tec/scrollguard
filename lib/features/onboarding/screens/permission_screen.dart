import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/services/permission_service.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> with WidgetsBindingObserver {
  bool _usageStatsGranted = false;
  bool _overlayGranted = false;
  bool _accessibilityGranted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final service = ref.read(permissionServiceProvider);
    final status = await service.getPermissionStatus();
    
    if (mounted) {
      setState(() {
        _usageStatsGranted = status.usageStats;
        _overlayGranted = status.overlay;
        _accessibilityGranted = status.accessibility;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allGranted = _usageStatsGranted && _overlayGranted && _accessibilityGranted;

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
                    const SizedBox(height: 24),
                    
                    // ═══════════════════════════════════════════════════════
                    // INFO CARD
                    // ═══════════════════════════════════════════════════════
                    
                    _buildInfoCard()
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    Text(
                      'Required Permissions',
                      style: AppTypography.headlineSmall,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms),
                    
                    const SizedBox(height: 16),
                    
                    // ═══════════════════════════════════════════════════════
                    // PERMISSION CARDS
                    // ═══════════════════════════════════════════════════════
                    
                    _buildPermissionCard(
                      index: 0,
                      icon: Icons.bar_chart_rounded,
                      title: 'Usage Access',
                      description: 'To track time spent on social apps',
                      isGranted: _usageStatsGranted,
                      onTap: _requestUsageStats,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildPermissionCard(
                      index: 1,
                      icon: Icons.layers_rounded,
                      title: 'Display Over Apps',
                      description: 'To show mindful intervention screens',
                      isGranted: _overlayGranted,
                      onTap: _requestOverlay,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildPermissionCard(
                      index: 2,
                      icon: Icons.accessibility_new_rounded,
                      title: 'Accessibility Service',
                      description: 'To detect which app you\'re using',
                      isGranted: _accessibilityGranted,
                      onTap: _requestAccessibility,
                    ),
                    
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // COMPLETE BUTTON
            // ═══════════════════════════════════════════════════════════════
            
            _buildCompleteButton(allGranted),
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
              'Step 2 of 2',
              style: AppTypography.labelMedium,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.security_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy Matters',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All data stays on your device. We never collect or share your information.',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isGranted ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isGranted 
              ? AppColors.success.withOpacity(0.1) 
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isGranted 
                ? AppColors.success.withOpacity(0.4) 
                : AppColors.glassBorder,
            width: isGranted ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGranted 
                    ? AppColors.success.withOpacity(0.2) 
                    : AppColors.surfaceLight,
              ),
              child: Icon(
                isGranted ? Icons.check_rounded : icon,
                color: isGranted ? AppColors.success : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: isGranted 
                          ? AppColors.success 
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            if (!isGranted)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textTertiary,
                size: 16,
              ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 400.ms, delay: (200 + index * 100).ms)
    .slideX(begin: 0.1, end: 0);
  }

  Widget _buildCompleteButton(bool allGranted) {
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
          if (!allGranted)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Grant all permissions to continue',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: allGranted ? AppColors.primaryGradient : null,
              color: allGranted ? null : AppColors.surfaceLight,
              boxShadow: allGranted ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ] : null,
            ),
            child: ElevatedButton(
              onPressed: allGranted ? _onComplete : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnPrimary,
                      ),
                    )
                  : Text(
                      'Complete Setup',
                      style: AppTypography.labelLarge.copyWith(
                        color: allGranted 
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

  Future<void> _requestUsageStats() async {
    HapticFeedback.selectionClick();
    
    await _showPermissionGuide(
      title: 'Enable Usage Access',
      icon: Icons.bar_chart_rounded,
      steps: [
        'Find "ScrollGuard" in the list',
        'Tap on it to open settings',
        'Toggle "Permit usage access" ON',
      ],
      onContinue: () async {
        final service = ref.read(permissionServiceProvider);
        await service.requestUsageStatsPermission();
      },
    );
  }

  Future<void> _requestOverlay() async {
    HapticFeedback.selectionClick();
    final service = ref.read(permissionServiceProvider);
    await service.requestOverlayPermission();
  }

  Future<void> _requestAccessibility() async {
    HapticFeedback.selectionClick();
    
    await _showPermissionGuide(
      title: 'Enable Accessibility',
      icon: Icons.accessibility_new_rounded,
      steps: [
        'Tap on "Installed Apps" (or Downloaded Apps)',
        'Find "ScrollGuard" in the list',
        'Toggle "Use ScrollGuard" ON',
        'Tap "Allow" to confirm',
      ],
      onContinue: () async {
        final service = ref.read(permissionServiceProvider);
        await service.openAccessibilitySettings();
      },
    );
  }

  Future<void> _showPermissionGuide({
    required String title,
    required IconData icon,
    required List<String> steps,
    required VoidCallback onContinue,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Text(title, style: AppTypography.titleMedium),
              ],
            ),
            const SizedBox(height: 24),
            ...steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                  onContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Open Settings'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _onComplete() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(settingsProvider.notifier).completeOnboarding();
      
      if (mounted) {
        context.go(Routes.dashboard);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
