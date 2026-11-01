import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../services/clock_service.dart';
import '../../../compare/model/store_price_model.dart';
import '../../model/offer_model.dart';

/// "Offer ends in 02 : 14 : 36" with start and end times underneath.
class CountdownCard extends StatelessWidget {
  final OfferModel offer;

  const CountdownCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<ClockService>(
      builder: (context, clock, child) {
        final remaining = clock.remainingUntil(offer.endsAt);
        final parts = Formatters.clock(remaining).split(':');
        final hasEnded = remaining.isNegative;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: colors.border, width: 1.2),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(LucideIcons.clock, size: 20, color: colors.warning),
                  const SizedBox(width: 8),
                  Text(
                    hasEnded ? 'Offer ended' : 'Offer ends in',
                    style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: colors.warning),
                  ),
                  const SizedBox(width: 8),
                  // The timer boxes shrink to fit on small phones.
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          for (var index = 0; index < parts.length; index++) ...[
                            if (index > 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(':', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w800)),
                              ),
                            Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.warningSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) => FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween(begin: const Offset(0, -0.3), end: Offset.zero).animate(animation),
                                    child: child,
                                  ),
                                ),
                                child: Text(
                                  parts[index],
                                  key: ValueKey(parts[index]),
                                  style: AppTextStyles.heading3.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colors.warning,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: colors.border),
              ),
              Row(
                children: [
                  Expanded(
                    child: TimeColumn(label: 'Started', value: Formatters.dayAndTime(offer.startedAt, clock.now)),
                  ),
                  Expanded(
                    child: TimeColumn(label: 'Ends', value: Formatters.dayAndTime(offer.endsAt, clock.now)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TimeColumn extends StatelessWidget {
  final String label;
  final String value;

  const TimeColumn({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15)),
      ],
    );
  }
}

/// "Also on 3 more stores – Compare to see the lowest price  PRO >"
class AlsoOnStoresCard extends StatelessWidget {
  final List<StorePriceModel> stores;
  final VoidCallback onTap;

  const AlsoOnStoresCard({super.key, required this.stores, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shown = stores.take(3).toList();

    return Pressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: colors.limeSoft, borderRadius: BorderRadius.circular(26)),
        child: Row(
          children: [
            SizedBox(
              width: 32.0 * shown.length + 16,
              height: 48,
              child: Stack(
                children: [
                  for (var index = 0; index < shown.length; index++)
                    Positioned(
                      left: index * 32.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.limeSoft, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 21,
                          backgroundColor: colors.surface,
                          child: Text(
                            shown[index].monogram,
                            style: AppTextStyles.tag.copyWith(fontSize: 13, color: colors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Also on ${stores.length} more stores',
                    style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15),
                  ),
                  Text(
                    'Compare to see the lowest price',
                    style: AppTextStyles.caption.copyWith(fontSize: 13, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const ProTag(fontSize: 11),
            const SizedBox(width: 8),
            Icon(LucideIcons.chevronRight, color: colors.textPrimary),
          ],
        ),
      ),
    );
  }
}

/// Small product row with name and a price, used on compare and redirect.
class ProductSummaryRow extends StatelessWidget {
  final String iconKey;
  final String tint;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const ProductSummaryRow({
    super.key,
    required this.iconKey,
    required this.tint,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProductImage(iconKey: iconKey, tint: tint, width: 56, height: 56, iconSize: 28, radius: 16),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.title),
              Text(subtitle, style: AppTextStyles.body.copyWith(color: context.colors.textSecondary)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
