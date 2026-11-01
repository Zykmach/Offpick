import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offpick/core/theme/app_text_styles.dart';
import 'package:offpick/core/theme/app_theme.dart';
import 'package:offpick/modules/alerts/model/alert_model.dart';
import 'package:offpick/modules/main_shell/controller/main_shell_controller.dart';
import 'package:offpick/routes/app_routes.dart';
import 'package:offpick/routes/route_arguments.dart';
import 'package:provider/provider.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

/// Opens every screen on small, medium and large phones, with normal and
/// large text, and fails if anything overflows or throws while drawing.
class ScreenCase {
  final String name;
  final String route;
  final Object? arguments;
  final int tab;

  const ScreenCase(this.name, this.route, {this.arguments, this.tab = -1});
}

class PhoneSize {
  final String name;
  final Size size;
  final double topInset;
  final double bottomInset;

  const PhoneSize(this.name, this.size, this.topInset, this.bottomInset);
}

const phones = [
  PhoneSize('iPhone SE 1st gen 320x568', Size(320, 568), 20, 0),
  PhoneSize('Small Android 360x640', Size(360, 640), 24, 0),
  PhoneSize('iPhone 15 393x852', Size(393, 852), 59, 34),
  PhoneSize('Pro Max 430x932', Size(430, 932), 59, 34),
];

const textScales = [1.0, 1.3];

final screens = [
  const ScreenCase('Welcome', AppRoutes.welcome),
  const ScreenCase('Login', AppRoutes.auth),
  const ScreenCase('Interests', AppRoutes.interests),
  const ScreenCase('Home', AppRoutes.main, tab: MainShellController.homeTab),
  const ScreenCase('Categories', AppRoutes.main, tab: MainShellController.categoriesTab),
  const ScreenCase('Compare tab', AppRoutes.main, tab: MainShellController.compareTab),
  const ScreenCase('Alerts', AppRoutes.main, tab: MainShellController.alertsTab),
  const ScreenCase('Profile', AppRoutes.main, tab: MainShellController.profileTab),
  const ScreenCase('Search', AppRoutes.search),
  const ScreenCase('Search results', AppRoutes.searchResults, arguments: 'shirt'),
  const ScreenCase('Category detail', AppRoutes.categoryDetail, arguments: CategoryArgs(categoryId: 'fashion')),
  const ScreenCase('Offer list', AppRoutes.offerList, arguments: OfferListArgs(subcategoryId: 'men-shirts')),
  const ScreenCase('Coupon deal details', AppRoutes.productDetails, arguments: 'cl-1'),
  const ScreenCase('Product details', AppRoutes.productDetails, arguments: 'cl-4'),
  const ScreenCase('Saved offers', AppRoutes.savedOffers),
  const ScreenCase('Compare prices', AppRoutes.comparePrices, arguments: 'cl-4'),
  const ScreenCase('Redirect', AppRoutes.redirect, arguments: RedirectArgs(offerId: 'cl-1')),
  ScreenCase(
    'Alert created',
    AppRoutes.alertCreated,
    arguments: AlertCreatedArgs(alert: AlertModel.fromJson(Fixtures.alert), previewBody: 'Flat 60% off on Pantaloons.'),
  ),
  const ScreenCase('Paywall', AppRoutes.paywall),
];

void main() {
  // Load every bundled font first, so the first screen is measured with real fonts.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
    final styles = [
      AppTextStyles.display, AppTextStyles.heading1, AppTextStyles.heading2, AppTextStyles.heading3,
      AppTextStyles.title, AppTextStyles.titleSmall, AppTextStyles.priceHuge, AppTextStyles.priceLarge,
      AppTextStyles.price, AppTextStyles.priceSmall, AppTextStyles.body, AppTextStyles.bodyMedium,
      AppTextStyles.bodySemiBold, AppTextStyles.caption, AppTextStyles.captionMedium, AppTextStyles.label,
      AppTextStyles.tag, AppTextStyles.button,
    ];
    expect(styles, isNotEmpty);
    expect(AppTheme.light, isNotNull);
    await GoogleFonts.pendingFonts();
  });

  for (final phone in phones) {
    for (final scale in textScales) {
      testWidgets('${phone.name}, text x$scale', (tester) async {
        tester.view.devicePixelRatio = 3;
        tester.view.physicalSize = phone.size * 3;
        tester.view.padding = FakeViewPadding(top: phone.topInset * 3, bottom: phone.bottomInset * 3);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final problems = <String>[];
        for (final screen in screens) {
          final original = FlutterError.onError;
          FlutterError.onError = (details) {
            final source = RegExp(r'lib/[\w/]+\.dart:\d+').firstMatch(details.toString())?.group(0) ?? '';
            problems.add('${screen.name}: ${details.exceptionAsString().split('\n').first} $source');
          };
          try {
            final app = await tester.runAsync(() => buildTestApp(screen.route, arguments: screen.arguments));
            await tester.pumpWidget(app!);
            if (screen.tab >= 0) {
              tester.element(find.byType(MaterialApp)).read<MainShellController>().setTab(screen.tab);
            }
            for (var frame = 0; frame < 25; frame++) {
              await tester.pump(const Duration(milliseconds: 100));
            }
          } finally {
            await tester.pumpWidget(const SizedBox());
            await tester.pump(const Duration(seconds: 3));
            FlutterError.onError = original;
          }
        }
        expect(problems.toSet().toList(), isEmpty, reason: '${phone.name} text x$scale');
      });
    }
  }
}
