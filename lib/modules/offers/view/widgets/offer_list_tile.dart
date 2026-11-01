import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/countdown_badge.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../../../core/widgets/product_image.dart';
import '../../model/offer_model.dart';
import '../offer_actions.dart';
import 'offer_price_row.dart';

/// Horizontal offer card used in category lists and saved offers.
class OfferListTile extends StatelessWidget {
  final OfferModel offer;
  final Widget? trailing;

  const OfferListTile({super.key, required this.offer, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      padding: const EdgeInsets.all(10),
      onTap: () => OfferActions.openDetails(context, offer),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 112,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImage(
                      iconKey: offer.iconKey,
                      tint: offer.tint,
                      iconSize: 42,
                      heroTag: 'offer-image-${offer.id}',
                    ),
                  ),
                  Positioned(left: 8, top: 8, child: DiscountBadge(percent: offer.discountPercent, compact: true, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${offer.brand} · ${offer.storeName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(fontSize: 13, color: colors.textSecondary),
                          ),
                        ),
                        if (trailing != null) trailing!,
                        if (trailing == null && offer.isNew)
                          Text('NEW', style: AppTextStyles.tag.copyWith(fontSize: 11, color: colors.accent)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    OfferPriceRow(offer: offer, priceStyle: AppTextStyles.price, mrpSize: 12),
                    const SizedBox(height: 14),
                    CountdownBadge(endsAt: offer.endsAt, style: CountdownStyle.pillWithPrefix, fontSize: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
