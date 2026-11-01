import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'pressable.dart';

enum PillChipStyle {
  /// Selected chip turns dark, e.g. "For you", "Newest".
  solid,

  /// Selected chip turns soft lime with a lime border, e.g. store picks.
  outline,

  /// Grey chip that turns soft lime with green text, e.g. "Men › Shirts".
  tinted,
}

class PillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final PillChipStyle style;
  final double height;

  const PillChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.style = PillChipStyle.solid,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Color background = colors.surface;
    Color foreground = colors.textPrimary;
    Color border = colors.border;

    if (style == PillChipStyle.solid && selected) {
      background = colors.inverse;
      foreground = colors.onInverse;
      border = colors.inverse;
    } else if (style == PillChipStyle.outline && selected) {
      background = colors.limeSoft;
      border = AppColors.lime;
    } else if (style == PillChipStyle.tinted) {
      background = selected ? colors.limeSoft : colors.surfaceMuted;
      foreground = selected ? colors.accent : colors.textPrimary;
      border = Colors.transparent;
    }

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: style == PillChipStyle.tinted ? 14 : 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(style == PillChipStyle.tinted ? 12 : height / 2),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: foreground),
              const SizedBox(width: 8),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: foreground),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrolling row of chips that bleeds to the screen edge.
class ChipScroller extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;

  const ChipScroller({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final child in children) Padding(padding: const EdgeInsets.only(right: 8), child: child),
        ],
      ),
    );
  }
}
