import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../routes/route_arguments.dart';
import '../view/compare_prices_screen.dart';
import '../view/redirect_screen.dart';
import 'compare_controller.dart';
import 'compare_prices_controller.dart';
import 'redirect_controller.dart';

class CompareProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(
      create: (context) => CompareController(
        homeRepository: context.read(),
        userDataRepository: context.read(),
      ),
    );
  }

  static Widget pricesScreen(String offerId) {
    return ChangeNotifierProvider(
      create: (context) => ComparePricesController(
        homeRepository: context.read(),
        compareController: context.read(),
        offerId: offerId,
      )..load(),
      child: const ComparePricesScreen(),
    );
  }

  static Widget redirectScreen(RedirectArgs args) {
    return ChangeNotifierProvider(
      create: (context) => RedirectController(
        homeRepository: context.read(),
        catalogRepository: context.read(),
        linkService: context.read(),
        args: args,
      ),
      child: const RedirectScreen(),
    );
  }
}
