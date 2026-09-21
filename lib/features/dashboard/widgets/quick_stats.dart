import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/sanctuary_icons.dart';
import '../../../providers/providers.dart';

class QuickStatsRow extends ConsumerWidget {
  final AsyncValue<dynamic> usage;

  const QuickStatsRow({super.key, required this.usage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageData = usage.valueOrNull;
    final interventions = usageData?.interventionCount ?? 0;
    final dhikrCount = ref.watch(dhikrCountProvider);

    return Row(
      children: [
        // 1. Pauses today
        Expanded(
          child: _buildTelemetryCard(
            iconWidget: const CelestialMoonIcon(size: 17),
            label: 'Pauses today',
            value: '$interventions session${interventions == 1 ? '' : 's'}',
          ),
        ),
        const SizedBox(width: 12),
        // 2. Dhikr taps
        Expanded(
          child: _buildTelemetryCard(
            iconWidget: const MindfulHeartIcon(size: 17),
            label: 'Dhikr taps',
            value: '$dhikrCount completed',
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryCard({
    required Widget iconWidget,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              iconWidget,
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}



