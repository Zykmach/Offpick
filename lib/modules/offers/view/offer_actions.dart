import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../pro/controller/pro_gate.dart';
import '../model/offer_model.dart';

/// Navigation used by every offer card, so cards behave the same everywhere.
class OfferActions {
  static void openDetails(BuildContext context, OfferModel offer) {
    Navigator.of(context).pushNamed(AppRoutes.productDetails, arguments: offer.id);
  }

  static void viewDeal(BuildContext context, OfferModel offer) {
    Navigator.of(context).pushNamed(
      AppRoutes.redirect,
      arguments: RedirectArgs(offerId: offer.id, price: offer.price),
    );
  }

  /// Compare is a Pro feature, free users see the paywall first.
  static void compare(BuildContext context, String offerId) {
    ProGate.run(context, () {
      Navigator.of(context).pushNamed(AppRoutes.comparePrices, arguments: offerId);
    });
  }
}
