import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/badges.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/product_image.dart';
import '../../alerts/model/alert_target_option.dart';
import '../../alerts/view/set_alert_sheet.dart';
import '../controller/product_details_controller.dart';
import 'offer_actions.dart';
import 'widgets/product_gallery.dart';
import 'widgets/product_info_cards.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  void setAlert(BuildContext context, ProductDetailsController controller) {
    final offer = controller.offer!;
    final subcategory = controller.subcategory;
    openSetAlert(context, [
      AlertTargetOption.forOffer(offer),
      if (subcategory != null) AlertTargetOption.forSubcategory(subcategory, controller.category?.name ?? ''),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Consumer<ProductDetailsController>(
        builder: (context, controller, child) {
          final offer = controller.offer;
          if (controller.isLoading && offer == null) return const AppLoader();
          if (offer == null) {
            return SafeArea(
              child: Column(
                children: [
                  const ScreenHeader(title: ''),
                  Expanded(
                    child: EmptyState(
                      icon: LucideIcons.tag,
                      title: 'Offer not found',
                      message: controller.errorMessage ?? 'It may have ended.',
                    ),
                  ),
                ],
              ),
            );
          }

          final otherStores = controller.otherStores;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProductGallery(
                        offer: offer,
                        currentPage: controller.imagePage,
                        pageCount: ProductDetailsController.imageCount,
                        onPageChanged: controller.setImagePage,
                        onShare: controller.share,
                      ),
                      Transform.translate(
                        offset: const Offset(0, -32),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(offer.brand.toUpperCase(), style: AppTextStyles.label.copyWith(fontSize: 14, color: colors.textSecondary)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(color: colors.border),
                                    ),
                                    child: Row(
                                      children: [
                                        StoreAvatar(monogram: offer.storeName[0], size: 26, circle: true),
                                        const SizedBox(width: 8),
                                        Text(offer.storeName, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              FadeSlideIn(child: Text(offer.title, style: AppTextStyles.heading1)),
                              const SizedBox(height: 14),
                              FadeSlideIn(
                                index: 1,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    PriceRow(
                                      price: offer.price,
                                      mrp: offer.mrp,
                                      priceStyle: AppTextStyles.priceLarge.copyWith(fontSize: 38),
                                      mrpSize: 20,
                                    ),
                                    DiscountBadge(percent: offer.discountPercent, fontSize: 15),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You save ${Formatters.price(offer.savings)}',
                                style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16, color: colors.accent),
                              ),
                              const SizedBox(height: 20),
                              FadeSlideIn(index: 2, child: CountdownCard(offer: offer)),
                              const SizedBox(height: 14),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: otherStores.isEmpty
                                    ? const SizedBox(width: double.infinity)
                                    : AlsoOnStoresCard(
                                        stores: otherStores,
                                        onTap: () => OfferActions.compare(context, offer.id),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: colors.background,
                  border: Border(top: BorderSide(color: colors.border)),
                ),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: LucideIcons.bellPlus,
                      size: 56,
                      onTap: () => setAlert(context, controller),
                      badge: const ProTag(lime: true, fontSize: 10),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppButton(
                        label: 'Compare',
                        icon: LucideIcons.arrowLeftRight,
                        type: AppButtonType.outline,
                        badge: const ProTag(),
                        onPressed: () => OfferActions.compare(context, offer.id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        label: 'View deal',
                        trailingIcon: LucideIcons.arrowUpRight,
                        onPressed: () => OfferActions.viewDeal(context, offer),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
