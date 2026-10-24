import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../../../core/widgets/product_image.dart';
import '../../model/comparison_model.dart';

/// "₹1,850 saved – by choosing the best store, vs where you found it"
class SavingsBanner extends StatelessWidget {
  final int amount;

  const SavingsBanner({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: colors.limeSoft, borderRadius: BorderRadius.circular(26)),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(16)),
            child: const Icon(LucideIcons.trendingDown, color: AppColors.onLime),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: amount.toDouble()),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Text(
                    '${Formatters.price(value.round())} saved',
                    style: AppTextStyles.priceLarge.copyWith(fontSize: 26),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'by choosing the best store, vs where you found it',
                  style: AppTextStyles.body.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackedProductCard extends StatelessWidget {
  final ComparisonModel comparison;
  final VoidCallback onTap;

  const TrackedProductCard({super.key, required this.comparison, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final saving = comparison.savingVsViewing;
    final storeLine = comparison.allSamePrice
        ? '${comparison.prices.length} stores · same price'
        : '${comparison.prices.length} stores · best on ${comparison.best.storeName}';

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ProductImage(iconKey: comparison.iconKey, tint: comparison.tint, width: 72, height: 72, iconSize: 30, radius: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comparison.productName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.title),
                Text(storeLine, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
                if (saving > 0) ...[
                  const SizedBox(height: 6),
                  InfoChip(
                    label: 'Save ${Formatters.price(saving)}',
                    background: colors.limeSoft,
                    textColor: colors.accent,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.price(comparison.best.price), style: AppTextStyles.price),
              if (!comparison.allSamePrice)
                Text(
                  'to ${Formatters.price(comparison.highestPrice)}',
                  style: AppTextStyles.body.copyWith(color: colors.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
