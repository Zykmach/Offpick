import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/form_controls.dart';
import '../../../../core/widgets/product_image.dart';
import '../../model/offer_model.dart';
import 'save_offer_button.dart';

/// Swipeable product images with back, share and save buttons on top.
class ProductGallery extends StatelessWidget {
  final OfferModel offer;
  final int currentPage;
  final int pageCount;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onShare;

  const ProductGallery({
    super.key,
    required this.offer,
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 340 + topPadding,
      color: colors.tint(offer.tint),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: pageCount,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final image = Padding(
                padding: EdgeInsets.only(top: topPadding + 40, bottom: 60),
                child: index == 0
                    ? ProductImage(
                        iconKey: offer.iconKey,
                        tint: offer.tint,
                        radius: 0,
                        iconSize: 150,
                        heroTag: 'offer-image-${offer.id}',
                      )
                    : Center(
                        child: Transform.scale(
                          scaleX: index == 1 ? -1 : 1,
                          child: AppIcon(offer.iconKey, size: index == 1 ? 140 : 120, color: colors.placeholderIcon),
                        ),
                      ),
              );
              return image;
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            top: topPadding + 8,
            child: Row(
              children: [
                CircleIconButton(
                  icon: LucideIcons.chevronLeft,
                  background: colors.surface,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                const Spacer(),
                CircleIconButton(icon: LucideIcons.share2, background: colors.surface, onTap: onShare),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SaveOfferButton(offer: offer, size: 52),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 52,
            child: Center(child: PageDots(count: pageCount, current: currentPage)),
          ),
        ],
      ),
    );
  }
}
