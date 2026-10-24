import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../../../core/widgets/pressable.dart';
import '../../model/category_model.dart';
import '../../model/subcategory_model.dart';

/// One category on the Categories tab, with its quick links underneath.
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final ValueChanged<String> onGroupTap;
  final ValueChanged<SubcategoryModel> onSubcategoryTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onGroupTap,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subcategories = category.subcategories;
    final showMore = subcategories.length > 4;
    final visible = showMore ? subcategories.take(3).toList() : subcategories;

    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.tint(category.tint),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: AppIcon(category.iconKey, size: 26, color: colors.textPrimary)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w500, fontSize: 21)),
                    Text(
                      '${category.liveOffers} live offers',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 16, color: colors.accent),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: colors.textPrimary),
            ],
          ),
          const SizedBox(height: 16),
          if (category.hasGroups)
            Row(
              children: [
                for (var index = 0; index < category.groups.length; index++) ...[
                  if (index > 0) const SizedBox(width: 10),
                  Expanded(
                    child: QuickLink(
                      label: category.groups[index][0].toUpperCase() + category.groups[index].substring(1),
                      centered: true,
                      onTap: () => onGroupTap(category.groups[index]),
                    ),
                  ),
                ],
              ],
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final subcategory in visible)
                  QuickLink(label: subcategory.name, onTap: () => onSubcategoryTap(subcategory)),
                if (showMore)
                  QuickLink(label: '+${subcategories.length - 3} more', muted: true, onTap: onTap),
              ],
            ),
        ],
      ),
    );
  }
}

/// Grey rounded link like "Skincare" or "Men".
class QuickLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool centered;
  final bool muted;

  const QuickLink({super.key, required this.label, required this.onTap, this.centered = false, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: centered ? Alignment.center : null,
        decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 16,
                fontWeight: centered ? FontWeight.w600 : FontWeight.w500,
                color: muted ? colors.textSecondary : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
