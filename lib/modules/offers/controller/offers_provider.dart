import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../routes/route_arguments.dart';
import '../view/offer_list_screen.dart';
import '../view/product_details_screen.dart';
import '../view/saved_offers_screen.dart';
import 'offer_list_controller.dart';
import 'product_details_controller.dart';
import 'saved_offers_controller.dart';

class OffersProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(
      create: (context) => SavedOffersController(
        homeRepository: context.read(),
        userDataRepository: context.read(),
      ),
    );
  }

  static Widget listScreen(OfferListArgs args) {
    return ChangeNotifierProvider(
      create: (context) => OfferListController(
        homeRepository: context.read(),
        catalogRepository: context.read(),
        args: args,
      )..load(),
      child: const OfferListScreen(),
    );
  }

  static Widget detailsScreen(String offerId) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailsController(
        homeRepository: context.read(),
        catalogRepository: context.read(),
        linkService: context.read(),
        offerId: offerId,
      )..load(),
      child: const ProductDetailsScreen(),
    );
  }

  static Widget savedScreen() => const SavedOffersScreen();
}
