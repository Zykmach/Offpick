import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/countdown_badge.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../services/clock_service.dart';
import '../../../offers/model/offer_model.dart';
import '../../../offers/view/offer_actions.dart';
import '../../../offers/view/widgets/save_offer_button.dart';

/// Large offer card on the Home feed.
class HomeOfferCard extends StatelessWidget {
  final OfferModel offer;

  const HomeOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => OfferActions.openDetails(context, offer),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 190,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImage(
                      iconKey: offer.iconKey,
                      tint: offer.tint,
                      radius: 0,
                      iconSize: 70,
                      heroTag: 'offer-image-${offer.id}',
                    ),
                  ),
                  Positioned(left: 14, top: 14, child: DiscountBadge(percent: offer.discountPercent)),
                  Positioned(
                    right: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(14)),
                      child: Text(offer.storeName, style: AppTextStyles.captionMedium.copyWith(fontSize: 14)),
                    ),
                  ),
                  Positioned(right: 14, bottom: 12, child: SaveOfferButton(offer: offer, size: 42)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.brand.toUpperCase(),
                    style: AppTextStyles.label.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(offer.title, style: AppTextStyles.title.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: PriceRow(
                            price: offer.price,
                            mrp: offer.mrp,
                            priceStyle: AppTextStyles.priceLarge.copyWith(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CountdownBadge(endsAt: offer.endsAt, fontSize: 14),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Consumer<ClockService>(
                    builder: (context, clock, child) => Text(
                      'Started ${Formatters.ago(offer.startedAt, clock.now)} · '
                      'Ends ${Formatters.dayAndTime(offer.endsAt, clock.now).replaceFirst('Today', 'today')}',
                      style: AppTextStyles.caption.copyWith(fontSize: 14, color: colors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Compare',
                          icon: LucideIcons.arrowLeftRight,
                          type: AppButtonType.outline,
                          badge: const ProTag(),
                          height: 46,
                          radius: 16,
                          onPressed: () => OfferActions.compare(context, offer.id),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'View deal',
                          trailingIcon: LucideIcons.arrowUpRight,
                          height: 46,
                          radius: 16,
                          onPressed: () => OfferActions.viewDeal(context, offer),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
