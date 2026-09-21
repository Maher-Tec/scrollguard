import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/intervention_type.dart';
import '../../../providers/providers.dart';
import '../../../router.dart';

class BreathingExercise extends ConsumerStatefulWidget {
  const BreathingExercise({super.key});

  @override
  ConsumerState<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends ConsumerState<BreathingExercise>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _scaleAnimation;
  
  BreathingPhase _currentPhase = BreathingPhase.inhale;
  int _currentCycle = 1;
  int _phaseSecondsRemaining = 4;
  bool _isComplete = false;
  Timer? _phaseTimer;

  @override
  void initState() {
    super.initState();
    
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOutSine,
    ));
    
    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    _runPhase(_currentPhase);
  }

  void _runPhase(BreathingPhase phase) {
    setState(() {
      _currentPhase = phase;
      _phaseSecondsRemaining = phase.durationSeconds;
    });
    
    // Animate circle based on phase
    switch (phase) {
      case BreathingPhase.inhale:
        _breatheController.forward();
        _triggerHaptic();
        break;
      case BreathingPhase.holdIn:
        // Stay expanded
        break;
      case BreathingPhase.exhale:
        _breatheController.reverse();
        _triggerHaptic();
        break;
      case BreathingPhase.holdOut:
        // Stay contracted
        break;
    }
    
    // Countdown timer for phase
    _phaseTimer?.cancel();
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _phaseSecondsRemaining--;
      });
      
      if (_phaseSecondsRemaining <= 0) {
        timer.cancel();
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    final nextPhase = _currentPhase.next;
    
    // Check if cycle complete (back to inhale)
    if (nextPhase == BreathingPhase.inhale) {
      if (_currentCycle >= AppConstants.breatheCycles) {
        _completeExercise();
        return;
      }
      setState(() {
        _currentCycle++;
      });
    }
    
    _runPhase(nextPhase);
  }

  Future<void> _triggerHaptic() async {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings?.hapticsEnabled ?? true) {
      try {
        final hasVibrator = await Vibration.hasVibrator() ?? false;
        if (hasVibrator) {
          Vibration.vibrate(duration: 50, amplitude: 64);
        }
      } catch (_) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _completeExercise() {
    _phaseTimer?.cancel();
    setState(() {
      _isComplete = true;
    });
    
    // Trigger success haptic
    HapticFeedback.mediumImpact();
    
    // Increment intervention count
    ref.read(usageProvider.notifier).incrementIntervention();
    
    // Reset session to allow usage again
    ref.read(usageProvider.notifier).startSession();
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sanctuary;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Animated background gradient
          _buildBackground(context),
          
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                
                const Spacer(),
                
                // Main breathing circle
                if (!_isComplete) ...[
                  _buildBreathingCircle(),
                  const SizedBox(height: 48),
                  _buildInstructions(context),
                ] else ...[
                  _buildCompletionView(context),
                ],
                
                const Spacer(),
                
                // Progress / Continue
                if (!_isComplete)
                  _buildCycleProgress(context)
                else
                  _buildContinueButton(context),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final colors = context.sanctuary;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final intensity = _scaleAnimation.value;
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                _getPhaseColor().withValues(alpha: 0.15 * intensity),
                colors.background,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.sanctuary;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded),
            color: colors.textSecondary,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              'Box Breathing',
              style: AppTypography.labelMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBreathingCircle() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        final color = _getPhaseColor();
        
        return Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3 * scale),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
              
              // Middle ring
              Transform.scale(
                scale: 0.7 + (scale * 0.3),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                      width: 3,
                    ),
                  ),
                ),
              ),
              
              // Inner circle with timer
              Transform.scale(
                scale: 0.8 + (scale * 0.2),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_phaseSecondsRemaining',
                      style: AppTypography.timer.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructions(BuildContext context) {
    final colors = context.sanctuary;

    return Column(
      children: [
        Text(
          _currentPhase.instruction,
          style: AppTypography.breathing.copyWith(
            color: _getPhaseColor(),
          ),
        )
        .animate(
          key: ValueKey(_currentPhase),
        )
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          'Cycle $_currentCycle of ${AppConstants.breatheCycles}',
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCycleProgress(BuildContext context) {
    final colors = context.sanctuary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(AppConstants.breatheCycles, (index) {
          final isComplete = index < _currentCycle - 1;
          final isCurrent = index == _currentCycle - 1;
          
          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete 
                  ? AppColors.success 
                  : (isCurrent ? colors.primary : (colors.isDark ? AppColors.surfaceLight : const Color(0xFFCBD5E1))),
              border: isCurrent
                  ? Border.all(color: colors.primary, width: 2)
                  : null,
            ),
          );
        }),
      ),
    )
    .animate()
    .fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildCompletionView(BuildContext context) {
    final colors = context.sanctuary;

    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.success.withValues(alpha: 0.2),
                AppColors.success.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.5),
              width: 3,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 80,
              color: AppColors.success,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack),
        
        const SizedBox(height: 32),
        
        Text(
          'Well done',
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.success,
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms),
        
        const SizedBox(height: 12),
        
        Text(
          AppConstants.completionMessages[
            DateTime.now().second % AppConstants.completionMessages.length
          ],
          style: AppTypography.motivational.copyWith(
            color: colors.textPrimary,
          ),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 400.ms),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final colors = context.sanctuary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              colors.primary,
              colors.isDark ? const Color(0xFF47CDBB) : const Color(0xFF0F766E),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go(Routes.dashboard);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            'Return to Dashboard',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 500.ms, delay: 600.ms)
    .slideY(begin: 0.2, end: 0);
  }

  Color _getPhaseColor() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return AppColors.breatheInhale;
      case BreathingPhase.holdIn:
        return AppColors.breatheHold;
      case BreathingPhase.exhale:
        return AppColors.breatheExhale;
      case BreathingPhase.holdOut:
        return AppColors.breatheHold;
    }
  }
}
