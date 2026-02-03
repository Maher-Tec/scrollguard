import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              _buildAnimatedLogo(),
              
              const SizedBox(height: 48),
              
              Text(
                'ScrollGuard',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 16),
              
              Text(
                'Mindful moments for\ndigital wellness',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              
              const Spacer(flex: 3),
              
              _buildFeaturesList(),
              
              const Spacer(flex: 2),
              
              _buildGetStartedButton(context),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black, // Dark background to blend with logo
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
               'assets/icon/icon.png',
               fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .scaleXY(begin: 1.0, end: 1.05, duration: 2000.ms, curve: Curves.easeInOut)
    .animate()
    .fadeIn(duration: 800.ms)
    .scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack);
  }

  Widget _buildFeaturesList() {
    final features = [
      ('⏱️', 'Track social media time'),
      ('🫁', 'Gentle breathing exercises'),
      ('💡', 'Mindful interventions'),
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                feature.$1,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Text(
                feature.$2,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: (800 + index * 150).ms)
        .slideX(begin: -0.1, end: 0, curve: Curves.easeOutCubic);
      }).toList(),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => context.push(Routes.appSelection),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textOnPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms, delay: 1200.ms)
    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic);
  }
}
