import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Two (or more) option switcher with a sliding thumb.
/// Example: Log in / Sign up, Men / Women, Notifications / My alerts.
class SegmentedTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<int?>? badges;
  final double height;

  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.badges,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = labels.length;
    final alignX = count == 1 ? 0.0 : -1 + 2 * selectedIndex / (count - 1);

    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: BorderRadius.circular(height / 2.4)),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(alignX, 0),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 1 / count,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(height / 2.8),
                  boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 14, offset: const Offset(0, 4))],
                ),
              ),
            ),
          ),
          // Fills the whole track so every tab is centered and fully tappable.
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(count, (index) {
                final isSelected = index == selectedIndex;
                final badge = badges != null && index < badges!.length ? badges![index] : null;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(index),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: AppTextStyles.bodySemiBold.copyWith(
                            fontSize: 14,
                            color: isSelected ? colors.textPrimary : colors.textSecondary,
                          ),
                          child: Text(labels[index]),
                        ),
                        if (badge != null && badge > 0) ...[const SizedBox(width: 8), CountBadge(count: badge)],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small lime circle with a number in it.
class CountBadge extends StatelessWidget {
  final int count;

  const CountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(11)),
      child: Text('$count', style: AppTextStyles.tag.copyWith(fontSize: 11, color: AppColors.onLime)),
    );
  }
}
