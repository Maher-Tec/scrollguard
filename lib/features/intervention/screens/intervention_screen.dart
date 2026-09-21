import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/intervention_type.dart';
import '../../../data/models/intervention_mode.dart';
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
    final colors = context.sanctuary;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          _buildAnimatedBackground(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                32, 0, 32,
                MediaQuery.sizeOf(context).height * 0.45,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  _buildPulsingIcon(context)
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack),
                  const SizedBox(height: 28),
                  Text(
                    'Let\'s check in',
                    style: AppTypography.displaySmall.copyWith(
                      color: colors.textPrimary,
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
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 600.ms),
                  const SizedBox(height: 36),
                  _buildInterventionOptions(context)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 800.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  _buildContinueButton(context)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1000.ms),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(BuildContext context) {
    final colors = context.sanctuary;
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
                colors.primary.withValues(alpha: 0.15),
                colors.accent.withValues(alpha: 0.08),
                colors.background,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingIcon(BuildContext context) {
    final colors = context.sanctuary;
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
                color: colors.primary.withValues(alpha: opacity),
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
                    colors.primary.withValues(alpha: 0.3),
                    colors.accent.withValues(alpha: 0.2),
                  ],
                ),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text('🧘', style: TextStyle(fontSize: 56)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterventionOptions(BuildContext context) {
    final mode = ref.watch(settingsProvider).valueOrNull?.interventionMode ??
        InterventionMode.breathing;
    return Column(
      children: [
        if (mode != InterventionMode.breathing) ...[
          _buildOptionCard(
            context,
            icon: '☪',
            title: 'Dhikr',
            description: 'A short remembrance and tap counter',
            onTap: () => context.push(Routes.dhikr),
          ),
          if (mode == InterventionMode.both) const SizedBox(height: 12),
        ],
        if (mode != InterventionMode.dhikr)
          _buildOptionCard(
            context,
            icon: InterventionType.breathing.icon,
            title: InterventionType.breathing.displayName,
            description: 'Box breathing · 3 cycles',
            onTap: () => context.push(Routes.breathing),
          ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final colors = context.sanctuary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: colors.isDark ? 0.1 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final colors = context.sanctuary;
    return AnimatedOpacity(
      opacity: _canContinue ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: _canContinue ? _onContinue : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: colors.isDark ? AppColors.surfaceLight : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _canContinue ? colors.border : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                color: _canContinue
                    ? colors.textSecondary
                    : colors.textSecondary.withValues(alpha: 0.4),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                _canContinue
                    ? 'I\'m aware, continue'
                    : 'Wait $_countdownSeconds seconds...',
                style: AppTypography.labelLarge.copyWith(
                  color: _canContinue
                      ? colors.textSecondary
                      : colors.textSecondary.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
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
    ref.read(usageProvider.notifier).startSession();
    context.go(Routes.dashboard);
  }
}
