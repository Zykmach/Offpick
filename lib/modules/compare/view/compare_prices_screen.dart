import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../alerts/model/alert_target_option.dart';
import '../../alerts/view/set_alert_sheet.dart';
import '../../home/controller/home_controller.dart';
import '../../offers/view/widgets/product_info_cards.dart';
import '../controller/compare_prices_controller.dart';
import 'widgets/price_widgets.dart';

class ComparePricesScreen extends StatelessWidget {
  const ComparePricesScreen({super.key});

  void setAlert(BuildContext context, ComparePricesController controller) {
    final offers = context.read<HomeController>().offers.where((item) => item.id == controller.offerId);
    if (offers.isEmpty) return;
    openSetAlert(context, [AlertTargetOption.forOffer(offers.first)]);
  }

  void viewDeal(BuildContext context, ComparePricesController controller) {
    final selected = controller.selected;
    if (selected == null) return;
    Navigator.of(context).pushNamed(
      AppRoutes.redirect,
      arguments: RedirectArgs(offerId: controller.offerId, storeId: selected.storeId, price: selected.price),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Consumer<ComparePricesController>(
          builder: (context, controller, child) {
            final comparison = controller.comparison;
            final selected = controller.selected;

            return Column(
              children: [
                ScreenHeader(
                  title: 'Compare prices',
                  trailing: CircleIconButton(icon: LucideIcons.bell, onTap: () => setAlert(context, controller)),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const AppLoader()
                      : comparison == null
                          ? EmptyState(
                              icon: LucideIcons.arrowLeftRight,
                              title: "Couldn't compare prices",
                              message: controller.errorMessage ?? 'Please try again.',
                              action: AppButton(label: 'Try again', expand: false, onPressed: controller.load),
                            )
                          : ListView(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                              children: [
                                FadeSlideIn(
                                  child: ProductSummaryRow(
                                    iconKey: comparison.iconKey,
                                    tint: comparison.tint,
                                    title: comparison.productName,
                                    subtitle: '${comparison.variant} · ${comparison.prices.length} stores',
                                  ),
                                ),
                                const SizedBox(height: 18),
                                FadeSlideIn(index: 1, child: BestPriceCard(comparison: comparison)),
                                const SizedBox(height: 26),
                                Row(
                                  children: [
                                    Text('All stores', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w500)),
                                    const Spacer(),
                                    Text(
                                      'Updated ${Formatters.ago(comparison.updatedAt, DateTime.now())}',
                                      style: AppTextStyles.body.copyWith(color: colors.textSecondary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                FadeSlideIn(
                                  index: 2,
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: BorderRadius.circular(26),
                                      border: Border.all(color: colors.border, width: 1.2),
                                    ),
                                    child: Column(
                                      children: [
                                        for (final price in comparison.prices)
                                          StorePriceRow(
                                            price: price,
                                            isBest: price.storeId == comparison.best.storeId,
                                            isViewing: price.storeId == comparison.viewingStoreId,
                                            isSelected: price.storeId == selected?.storeId,
                                            showDivider: price != comparison.prices.last,
                                            onTap: () => controller.selectStore(price.storeId),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Tap a store to choose where to buy.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                                ),
                              ],
                            ),
                ),
                if (selected != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.border))),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: AppButton(
                        key: ValueKey(selected.storeId),
                        label: 'View deal on ${selected.storeName} · ${Formatters.price(selected.price)}',
                        trailingIcon: LucideIcons.arrowUpRight,
                        onPressed: () => viewDeal(context, controller),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
