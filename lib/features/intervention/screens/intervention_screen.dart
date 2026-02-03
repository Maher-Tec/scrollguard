import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/intervention_type.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';

class InterventionScreen extends ConsumerStatefulWidget {
  const InterventionScreen({super.key});

  @override
  ConsumerState<InterventionScreen> createState() => _InterventionScreenState();
}

class _InterventionScreenState extends ConsumerState<InterventionScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  
  int _countdownSeconds = AppConstants.minInterventionDisplaySeconds;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        _countdownSeconds--;
        if (_countdownSeconds <= 0) {
          _canContinue = true;
        }
      });
      
      return _countdownSeconds > 0;
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ═══════════════════════════════════════════════════════════════
          // ANIMATED BACKGROUND
          // ═══════════════════════════════════════════════════════════════
          
          _buildAnimatedBackground(),
          
          // ═══════════════════════════════════════════════════════════════
          // CONTENT
          // ═══════════════════════════════════════════════════════════════
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  
                  // Pulsing icon
                  _buildPulsingIcon()
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack),
                  
                  const SizedBox(height: 48),
                  
                  // Message
                  Text(
                    'Let\'s check in',
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'You\'ve been scrolling for a while.\nLet\'s pause for a moment.',
                    style: AppTypography.motivational.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms),
                  
                  const Spacer(flex: 2),
                  
                  // ═══════════════════════════════════════════════════════
                  // INTERVENTION OPTIONS
                  // ═══════════════════════════════════════════════════════
                  
                  _buildInterventionOptions()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms)
                  .slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Continue button (appears after countdown)
                  _buildContinueButton()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                0.5 * (1 - _backgroundController.value),
                -0.5 + (_backgroundController.value * 0.5),
              ),
              radius: 2.0,
              colors: [
                AppColors.primary.withOpacity(0.15),
                AppColors.accent.withOpacity(0.08),
                AppColors.background,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.1);
        final opacity = 0.3 + (_pulseController.value * 0.3);
        
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(opacity),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.accent.withOpacity(0.2),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  '🧘',
                  style: TextStyle(fontSize: 56),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterventionOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildOptionCard(
            type: InterventionType.breathing,
            onTap: () {
              HapticFeedback.mediumImpact();
              context.push(Routes.breathing);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOptionCard(
            type: InterventionType.grounding,
            onTap: () {
              HapticFeedback.mediumImpact();
              // TODO: Navigate to grounding exercise
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required InterventionType type,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              type.icon,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 16),
            Text(
              type.displayName,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type == InterventionType.breathing 
                  ? 'Box breathing\n3 cycles'
                  : '5-4-3-2-1\nsenses',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return AnimatedOpacity(
      opacity: _canContinue ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: _canContinue ? _onContinue : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _canContinue 
                  ? AppColors.glassBorder 
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                color: _canContinue 
                    ? AppColors.textSecondary 
                    : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                _canContinue 
                    ? 'I\'m aware, continue'
                    : 'Wait $_countdownSeconds seconds...',
                style: AppTypography.labelLarge.copyWith(
                  color: _canContinue 
                      ? AppColors.textSecondary 
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    HapticFeedback.lightImpact();
    
    // Reset session statistics (new session starts now)
    ref.read(usageProvider.notifier).startSession();
    
    // Close overlay and return to previous app
    context.go(Routes.dashboard);
  }
}
