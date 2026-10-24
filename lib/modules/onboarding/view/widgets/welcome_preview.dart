import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../services/clock_service.dart';
import '../../../../services/notification_service.dart';

/// The illustration on top of each welcome page.
class WelcomePreview extends StatelessWidget {
  final int pageIndex;
  final DateTime demoEndsAt;

  const WelcomePreview({super.key, required this.pageIndex, required this.demoEndsAt});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget content = CompareCardPreview(demoEndsAt: demoEndsAt);
    if (pageIndex == 1) content = const BestPricePreview();
    if (pageIndex == 2) content = const AlertsPreview();

    return Stack(
      alignment: Alignment.center,
      children: [
        PopIn(
          from: 0.6,
          duration: const Duration(milliseconds: 900),
          child: Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(color: colors.limeSoft, shape: BoxShape.circle),
          ),
        ),
        content,
      ],
    );
  }
}

/// White pill that floats over the illustration.
class FloatingPill extends StatelessWidget {
  final Widget child;

  const FloatingPill({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.border),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }
}

class PreviewStoreRow extends StatelessWidget {
  final String store;
  final int price;
  final bool isBest;

  const PreviewStoreRow({super.key, required this.store, required this.price, this.isBest = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isBest ? colors.limeSoft : colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isBest ? AppColors.lime : Colors.transparent, width: 1.4),
      ),
      child: Row(
        children: [
          Text(
            store,
            style: AppTextStyles.bodyMedium.copyWith(color: isBest ? colors.textPrimary : colors.textSecondary),
          ),
          const Spacer(),
          if (isBest) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(8)),
              child: Text('BEST', style: AppTextStyles.tag.copyWith(fontSize: 11, color: AppColors.onLime)),
            ),
            const SizedBox(width: 8),
          ],
          Text(Formatters.price(price), style: AppTextStyles.priceSmall.copyWith(fontSize: 16)),
        ],
      ),
    );
  }
}

class CompareCardPreview extends StatelessWidget {
  final DateTime demoEndsAt;

  const CompareCardPreview({super.key, required this.demoEndsAt});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 330,
      height: 330,
      child: Stack(
        children: [
          Positioned(
            left: 34,
            right: 34,
            top: 30,
            child: FadeSlideIn(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const ProductImage(iconKey: 'shirt', tint: 'green', width: 48, height: 48, iconSize: 24, radius: 14),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nike Casual Shirt', style: AppTextStyles.titleSmall),
                            Text('4 stores compared', style: AppTextStyles.caption.copyWith(color: colors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const PreviewStoreRow(store: 'Myntra', price: 999, isBest: true),
                    const PreviewStoreRow(store: 'AJIO', price: 1049),
                    const PreviewStoreRow(store: 'Flipkart', price: 1199),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 6,
            child: FadeSlideIn(
              index: 4,
              offsetX: 30,
              offsetY: 0,
              child: FloatingPill(
                child: Consumer<ClockService>(
                  builder: (context, clock, child) => Row(
                    children: [
                      Icon(LucideIcons.clock, size: 15, color: colors.warning),
                      const SizedBox(width: 6),
                      Text(
                        'Ends in ${Formatters.clock(clock.remainingUntil(demoEndsAt))}',
                        style: AppTextStyles.captionMedium.copyWith(color: colors.warning),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 8,
            child: FadeSlideIn(
              index: 6,
              offsetX: -30,
              offsetY: 0,
              child: FloatingPill(
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.bell, size: 14, color: AppColors.onLime),
                    ),
                    const SizedBox(width: 8),
                    Text("New offer in Men's Shirts", style: AppTextStyles.captionMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BestPricePreview extends StatelessWidget {
  const BestPricePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FadeSlideIn(
      child: Container(
        width: 270,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.lime, width: 1.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('BEST AVAILABLE PRICE', style: AppTextStyles.label.copyWith(fontSize: 11, color: colors.accent)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹999', style: AppTextStyles.priceLarge),
                const SizedBox(width: 10),
                const DiscountBadge(percent: 50),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(LucideIcons.trendingDown, size: 16, color: colors.accent),
                const SizedBox(width: 6),
                Text('₹200 less than Flipkart', style: AppTextStyles.captionMedium.copyWith(color: colors.accent)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlertsPreview extends StatelessWidget {
  const AlertsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeSlideIn(
            child: NotificationBanner(title: 'Price drop: Nike Casual Shirt', body: '₹1,999 → ₹999 · 50% OFF on Myntra'),
          ),
          SizedBox(height: 12),
          FadeSlideIn(
            index: 3,
            child: NotificationBanner(title: 'Ending soon', body: 'Sony WH-CH720N deal ends in 1 hour'),
          ),
        ],
      ),
    );
  }
}
