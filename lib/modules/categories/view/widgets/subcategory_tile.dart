import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/pressable.dart';

/// Square tile in "Shop by product": icon, name and offer count.
class SubcategoryTile extends StatelessWidget {
  final String name;
  final String iconKey;
  final String tint;
  final int offerCount;
  final VoidCallback onTap;
  final bool isViewAll;

  const SubcategoryTile({
    super.key,
    required this.name,
    required this.iconKey,
    required this.tint,
    required this.offerCount,
    required this.onTap,
    this.isViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isViewAll ? colors.surfaceMuted : colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.border, width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isViewAll ? colors.surface : colors.tint(tint),
                borderRadius: BorderRadius.circular(isViewAll ? 26 : 18),
              ),
              child: Center(
                child: isViewAll
                    ? Icon(LucideIcons.arrowRight, size: 22, color: colors.textPrimary)
                    : AppIcon(iconKey, size: 24, color: colors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '$offerCount offers',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(color: isViewAll ? colors.textSecondary : colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Never miss a drop" banner with a Set alert button.
class AlertBanner extends StatelessWidget {
  final String name;
  final VoidCallback onSetAlert;

  const AlertBanner({super.key, required this.name, required this.onSetAlert});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.limeSoft, borderRadius: BorderRadius.circular(26)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(14)),
            child: const Icon(LucideIcons.bell, color: AppColors.onLime),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Never miss a drop', style: AppTextStyles.titleSmall.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  'Alert me on new $name offers',
                  style: AppTextStyles.caption.copyWith(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Pressable(
            onTap: onSetAlert,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: colors.inverse, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Text('Set alert', style: AppTextStyles.bodySemiBold.copyWith(color: colors.onInverse)),
                  const SizedBox(width: 6),
                  const ProTag(lime: true, fontSize: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
