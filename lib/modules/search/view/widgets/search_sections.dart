import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../categories/model/category_model.dart';
import '../../../offers/model/offer_model.dart';
import '../../model/trending_model.dart';

class SearchSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SearchSectionTitle(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.heading3),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class RecentSearches extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onTap;

  const RecentSearches({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          PillChip(label: item, icon: LucideIcons.history, height: 46, onTap: () => onTap(item)),
      ],
    );
  }
}

class TrendingList extends StatelessWidget {
  final List<TrendingModel> items;
  final ValueChanged<TrendingModel> onTap;

  const TrendingList({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          FadeSlideIn(
            index: index,
            child: Pressable(
              pressedScale: 0.98,
              onTap: () => onTap(items[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  border: index == items.length - 1 ? null : Border(bottom: BorderSide(color: colors.border)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 34,
                      child: Text(
                        '${items[index].rank}',
                        style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w800, color: colors.accent),
                      ),
                    ),
                    Expanded(child: Text(items[index].title, style: AppTextStyles.bodyMedium.copyWith(fontSize: 17))),
                    Text(
                      'up to ${items[index].maxDiscount}% off',
                      style: AppTextStyles.body.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CategoryShortcuts extends StatelessWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onTap;

  const CategoryShortcuts({super.key, required this.categories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        for (var index = 0; index < categories.length; index++) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: Pressable(
              onTap: () => onTap(categories[index]),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.tint(categories[index].tint),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(child: AppIcon(categories[index].iconKey, size: 26, color: colors.textPrimary)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    categories[index].name.split(' ').first,
                    style: AppTextStyles.captionMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Matching offers shown while the user is typing.
class SearchSuggestions extends StatelessWidget {
  final List<OfferModel> offers;
  final ValueChanged<OfferModel> onTap;

  const SearchSuggestions({super.key, required this.offers, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (offers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Text('No matches yet, press search to look everywhere', style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
        ),
      );
    }
    return Column(
      children: [
        for (var index = 0; index < offers.length; index++)
          FadeSlideIn(
            index: index,
            child: Pressable(
              pressedScale: 0.98,
              onTap: () => onTap(offers[index]),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ProductImage(iconKey: offers[index].iconKey, tint: offers[index].tint, width: 52, height: 52, iconSize: 24, radius: 14),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offers[index].title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium),
                          Text(
                            '${offers[index].brand} · ${offers[index].storeName} · ${offers[index].discountPercent}% off',
                            style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(Formatters.price(offers[index].price), style: AppTextStyles.priceSmall.copyWith(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
