import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../offers/model/offer_model.dart';

/// The conditions a user can be alerted about.
enum AlertTrigger {
  newOffer('New offer', LucideIcons.tag),
  priceDrop('Price drop', LucideIcons.trendingDown),
  discount30('Discount above 30%', LucideIcons.percent),
  discount50('Discount above 50%', LucideIcons.percent),
  endingSoon('Offer ending soon', LucideIcons.clock);

  final String label;
  final IconData icon;
  const AlertTrigger(this.label, this.icon);

  String? description({required bool forProduct}) {
    switch (this) {
      case AlertTrigger.newOffer:
        return forProduct ? 'Any new deal on this product' : 'Any new deal in this category';
      case AlertTrigger.priceDrop:
        return 'When it gets cheaper on any store';
      case AlertTrigger.endingSoon:
        return '1 hour before it ends';
      default:
        return null;
    }
  }

  /// Text used in the sample notification on the "Your alert is on" screen.
  String previewTitle(String name) {
    switch (this) {
      case AlertTrigger.newOffer:
        return 'New offer: $name';
      case AlertTrigger.priceDrop:
        return 'Price drop: $name';
      case AlertTrigger.endingSoon:
        return 'Ending soon: $name';
      default:
        return '$label: $name';
    }
  }

  bool matches(OfferModel offer) {
    switch (this) {
      case AlertTrigger.discount30:
        return offer.discountPercent >= 30;
      case AlertTrigger.discount50:
        return offer.discountPercent >= 50;
      default:
        return true;
    }
  }

  static AlertTrigger fromName(String name) {
    return AlertTrigger.values.firstWhere((item) => item.name == name, orElse: () => AlertTrigger.newOffer);
  }
}
