import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/pressable.dart';

/// Selectable card with an icon, a label and a check mark.
class InterestTile extends StatelessWidget {
  final String label;
  final String iconKey;
  final bool selected;
  final VoidCallback onTap;

  const InterestTile({
    super.key,
    required this.label,
    required this.iconKey,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        decoration: BoxDecoration(
          color: selected ? colors.limeSoft : colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? AppColors.lime : colors.border, width: 1.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon(iconKey, size: 26, color: colors.textPrimary),
                const Spacer(),
                AnimatedScale(
                  scale: selected ? 1 : 0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                    child: const Icon(LucideIcons.check, size: 16, color: AppColors.onLime),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
