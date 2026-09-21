import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class DailyDhikrBanner extends StatelessWidget {
  const DailyDhikrBanner({super.key});

  static const _artworkUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1VeLdy3T18fwIgy1x2IKw0N5tmvya4ZuQnzJQOMGaGFZ7n4rMhK16jkcFGBqhLp8dYyjt1T5tXe9ptFRFVZ0MCQwT12G5YibBR0Lw88Nk_9KOhAgnAGTV2jEtEoAgOeYPd72ZUzZow32uud1MPYGiHcALYLteCfSeRACAB3M3tL6IWuzneMBvrZGR-_X9IUzQ0SpGk91UYF_ey6oczLVsjuFvxSu5JwlVMPrfRL6yjJbuNfP-LqsAucXbw';

  @override
  Widget build(BuildContext context) {
    const gold = AppColors.goldAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gold.withValues(alpha: 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sacred celestial artwork thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                border: Border.all(
                  color: gold.withValues(alpha: 0.45),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.25),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Image.network(
                _artworkUrl,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFF10231F),
                  child: Icon(
                    Icons.nights_stay_outlined,
                    color: gold,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: gold,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'SACRED CONTEMPLATION',
                      style: AppTypography.labelSmall.copyWith(
                        color: gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '"Verily, in the remembrance of Allah do hearts find rest."',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Surah Ar-Ra'd (13:28)",
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

