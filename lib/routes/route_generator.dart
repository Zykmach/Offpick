import 'package:flutter/material.dart';

import '../modules/alerts/controller/alerts_provider.dart';
import '../modules/auth/controller/auth_provider.dart';
import '../modules/categories/controller/categories_provider.dart';
import '../modules/compare/controller/compare_provider.dart';
import '../modules/interests/controller/interests_provider.dart';
import '../modules/main_shell/controller/main_shell_provider.dart';
import '../modules/offers/controller/offers_provider.dart';
import '../modules/onboarding/controller/onboarding_provider.dart';
import '../modules/pro/controller/pro_provider.dart';
import '../modules/search/controller/search_provider.dart';
import '../modules/splash/controller/splash_provider.dart';
import 'app_routes.dart';
import 'page_transitions.dart';
import 'route_arguments.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;
    Widget page;
    var transition = TransitionType.slide;

    switch (settings.name) {
      case AppRoutes.splash:
        page = SplashProvider.screen();
        transition = TransitionType.fade;
      case AppRoutes.welcome:
        page = OnboardingProvider.screen();
        transition = TransitionType.fade;
      case AppRoutes.auth:
        page = AuthProvider.authScreen();
        transition = TransitionType.fade;
      case AppRoutes.interests:
        final isEditing = args == true;
        page = InterestsProvider.screen(isEditing: isEditing);
        if (!isEditing) transition = TransitionType.fade;
      case AppRoutes.main:
        page = MainShellProvider.screen();
        transition = TransitionType.fade;
      case AppRoutes.search:
        page = SearchProvider.searchScreen();
        transition = TransitionType.slideUp;
      case AppRoutes.searchResults:
        page = SearchProvider.resultsScreen(args as String);
      case AppRoutes.categoryDetail:
        page = CategoriesProvider.detailScreen(args as CategoryArgs);
      case AppRoutes.offerList:
        page = OffersProvider.listScreen(args is OfferListArgs ? args : const OfferListArgs());
      case AppRoutes.productDetails:
        page = OffersProvider.detailsScreen(args as String);
      case AppRoutes.savedOffers:
        page = OffersProvider.savedScreen();
      case AppRoutes.comparePrices:
        page = CompareProvider.pricesScreen(args as String);
      case AppRoutes.redirect:
        page = CompareProvider.redirectScreen(args as RedirectArgs);
        transition = TransitionType.slideUp;
      case AppRoutes.alertCreated:
        page = AlertsProvider.createdScreen(args as AlertCreatedArgs);
        transition = TransitionType.slideUp;
      case AppRoutes.paywall:
        page = ProProvider.paywallScreen();
        transition = TransitionType.slideUp;
      default:
        page = MainShellProvider.screen();
    }

    return AppPageRoute(page: page, settings: settings, type: transition);
  }
}
