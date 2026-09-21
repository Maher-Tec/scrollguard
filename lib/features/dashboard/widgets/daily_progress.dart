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
    final progress = (timeLimit > 0)
        ? (totalMinutes / timeLimit).clamp(0.0, 1.0)
        : 0.0;
    final remaining = (timeLimit - totalMinutes).clamp(0, timeLimit);

    final statusColor = _getStatusColor(progress);

    return Container(
      padding: const EdgeInsets.all(22),
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
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Session Limit',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _getStatusText(progress),
                  style: AppTypography.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Enhanced gradient progress bar
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 10,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.7),
                            statusColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 14),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatTime(totalMinutes)} used',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                remaining > 0 ? '${_formatTime(remaining)} left' : 'Limit reached',
                style: AppTypography.bodySmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(double progress) {
    if (progress < 0.5) return AppColors.success;
    if (progress < 0.8) return AppColors.warning;
    return AppColors.error;
  }

  String _getStatusText(double progress) {
    if (progress < 0.5) return 'On Track';
    if (progress < 0.8) return 'Approaching';
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
