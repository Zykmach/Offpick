import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/countdown_badge.dart';
import '../../../../core/widgets/product_image.dart';
import '../../model/comparison_model.dart';
import '../../model/store_price_model.dart';

/// Lime card with the cheapest price.
class BestPriceCard extends StatelessWidget {
  final ComparisonModel comparison;

  const BestPriceCard({super.key, required this.comparison});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final best = comparison.best;
    final other = comparison.compareAgainst;
    final difference = other.price - best.price;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.limeSoft,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.lime, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('BEST AVAILABLE PRICE', style: AppTextStyles.label.copyWith(color: colors.accent)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 14, 5),
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    StoreAvatar(monogram: best.monogram, size: 26, circle: true, highlighted: true),
                    const SizedBox(width: 8),
                    Text(best.storeName, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 12,
            runSpacing: 6,
            children: [
              Text(Formatters.price(best.price), style: AppTextStyles.priceHuge.copyWith(fontSize: 36)),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  Formatters.price(best.mrp),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: colors.textMuted,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: colors.textMuted,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: DiscountBadge(percent: best.discountPercent, fontSize: 13),
              ),
            ],
          ),
          if (difference > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(LucideIcons.trendingDown, size: 18, color: colors.accent),
                const SizedBox(width: 8),
                Text(
                  '${Formatters.price(difference)} less than ${other.storeName}',
                  style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: colors.accent),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// One store in "All stores".
class StorePriceRow extends StatelessWidget {
  final StorePriceModel price;
  final bool isBest;
  final bool isViewing;
  final bool isSelected;
  final bool showDivider;
  final VoidCallback onTap;

  const StorePriceRow({
    super.key,
    required this.price,
    required this.isBest,
    required this.isViewing,
    required this.isSelected,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.limeSoft.withValues(alpha: 0.6) : Colors.transparent,
          border: showDivider ? Border(bottom: BorderSide(color: colors.border)) : null,
        ),
        child: Row(
          children: [
            StoreAvatar(monogram: price.monogram, size: 48, highlighted: isBest),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(price.storeName, style: AppTextStyles.title.copyWith(fontSize: 16))),
                      if (isBest) ...[const SizedBox(width: 8), StoreTag(label: 'BEST', color: colors.accent, background: colors.limeSoft)],
                      if (isViewing && !isBest) ...[
                        const SizedBox(width: 8),
                        StoreTag(label: 'VIEWING', color: colors.textSecondary, background: colors.surfaceMuted),
                      ],
                    ],
                  ),
                  CountdownBadge(endsAt: price.endsAt, style: CountdownStyle.text, fontSize: 14),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Formatters.price(price.price), style: AppTextStyles.price),
                Text(
                  '${price.discountPercent}% off',
                  style: AppTextStyles.bodyMedium.copyWith(color: isBest ? colors.accent : colors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoreTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const StoreTag({super.key, required this.label, required this.color, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: AppTextStyles.tag.copyWith(fontSize: 10, color: color, letterSpacing: 0.4)),
    );
  }
}
