import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/countdown_badge.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../../core/widgets/product_image.dart';
import '../../model/offer_model.dart';
import '../offer_actions.dart';

/// Two-column card used on the search results grid.
class OfferGridCard extends StatelessWidget {
  final OfferModel offer;

  const OfferGridCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      pressedScale: 0.97,
      onTap: () => OfferActions.openDetails(context, offer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.05,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ProductImage(
                    iconKey: offer.iconKey,
                    tint: offer.tint,
                    radius: 22,
                    iconSize: 54,
                    heroTag: 'offer-image-${offer.id}',
                  ),
                ),
                Positioned(left: 10, top: 10, child: DiscountBadge(percent: offer.discountPercent, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${offer.brand} · ${offer.storeName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(fontSize: 14, color: colors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            offer.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title.copyWith(fontSize: 17, height: 1.2),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: PriceRow(price: offer.price, mrp: offer.mrp, priceStyle: AppTextStyles.price, mrpSize: 13),
          ),
          const SizedBox(height: 4),
          CountdownBadge(endsAt: offer.endsAt, style: CountdownStyle.inline, fontSize: 14),
        ],
      ),
    );
  }
}
