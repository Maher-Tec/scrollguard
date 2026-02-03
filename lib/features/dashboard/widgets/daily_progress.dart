import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class DailyProgressCard extends ConsumerWidget {
  final AsyncValue<dynamic> settings;
  final AsyncValue<dynamic> usage;

  const DailyProgressCard({
    super.key,
    required this.settings,
    required this.usage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsData = settings.valueOrNull;
    final usageData = usage.valueOrNull;
    
    final timeLimit = settingsData?.timeLimitMinutes ?? 30;
    final totalMinutes = usageData?.totalMinutes ?? 0;
    final progress = (totalMinutes / timeLimit).clamp(0.0, 1.0);
    final remaining = (timeLimit - totalMinutes).clamp(0, timeLimit);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Progress',
                style: AppTypography.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(progress).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(progress),
                  style: AppTypography.labelSmall.copyWith(
                    color: _getStatusColor(progress),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatTime(totalMinutes)} used',
                style: AppTypography.bodyMedium,
              ),
              Text(
                '${_formatTime(remaining)} remaining',
                style: AppTypography.bodyMedium.copyWith(
                  color: _getStatusColor(progress),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) return AppColors.success;
    if (progress < 0.75) return AppColors.warning;
    return AppColors.error;
  }

  Color _getStatusColor(double progress) {
    if (progress < 0.5) return AppColors.success;
    if (progress < 0.75) return AppColors.warning;
    if (progress < 1.0) return AppColors.error;
    return AppColors.error;
  }

  String _getStatusText(double progress) {
    if (progress < 0.5) return 'On Track';
    if (progress < 0.75) return 'Halfway There';
    if (progress < 1.0) return 'Almost Limit';
    return 'Limit Reached';
  }

  String _formatTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}
