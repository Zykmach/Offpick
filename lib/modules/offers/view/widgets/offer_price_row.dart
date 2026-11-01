import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../model/offer_model.dart';

/// Price with the struck-out MRP for product offers, or the deal text
/// ("Code SAVE10", "60% off") for coupon and store-wide deals.
class OfferPriceRow extends StatelessWidget {
  final OfferModel offer;
  final TextStyle priceStyle;
  final double mrpSize;

  const OfferPriceRow({super.key, required this.offer, required this.priceStyle, this.mrpSize = 15});

  @override
  Widget build(BuildContext context) {
    if (offer.hasPrice) {
      return PriceRow(price: offer.price!, mrp: offer.mrp!, priceStyle: priceStyle, mrpSize: mrpSize);
    }
    return Text(
      offer.dealLabel,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: priceStyle.copyWith(fontSize: (priceStyle.fontSize ?? 20) * 0.8, color: context.colors.accent),
    );
  }
}
