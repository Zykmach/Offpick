import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Tiny "PRO" label shown on paid features.
class ProTag extends StatelessWidget {
  final bool lime;
  final double fontSize;

  const ProTag({super.key, this.lime = false, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: fontSize * 0.6, vertical: fontSize * 0.2),
      decoration: BoxDecoration(
        color: lime ? AppColors.lime : colors.inverse,
        borderRadius: BorderRadius.circular(fontSize * 0.55),
      ),
      child: Text(
        'PRO',
        style: AppTextStyles.tag.copyWith(
          fontSize: fontSize,
          letterSpacing: 0.4,
          color: lime ? AppColors.onLime : colors.onInverse,
        ),
      ),
    );
  }
}

/// Lime pill with a crown, e.g. "PRO" next to the Compare title.
class CrownTag extends StatelessWidget {
  final String label;

  const CrownTag({super.key, this.label = 'PRO'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.crown, size: 14, color: AppColors.onLime),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.tag.copyWith(color: AppColors.onLime, letterSpacing: 0.6)),
        ],
      ),
    );
  }
}

/// "52% OFF" lime badge. Use [compact] for just "52%".
class DiscountBadge extends StatelessWidget {
  final int percent;
  final bool compact;
  final double fontSize;

  const DiscountBadge({super.key, required this.percent, this.compact = false, this.fontSize = 13});

  @override
  Widget build(BuildContext context) {
    if (percent <= 0) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: fontSize * 0.7, vertical: fontSize * 0.35),
      decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(8)),
      child: Text(
        compact ? '$percent%' : '$percent% OFF',
        style: AppTextStyles.tag.copyWith(fontSize: fontSize, color: AppColors.onLime),
      ),
    );
  }
}

/// Small rounded grey tag, e.g. "Price drop" on an alert card.
class InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? background;
  final Color? textColor;

  const InfoChip({super.key, required this.label, this.icon, this.background, this.textColor});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = textColor ?? colors.textPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background ?? colors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: foreground), const SizedBox(width: 6)],
          Text(label, style: AppTextStyles.captionMedium.copyWith(color: foreground)),
        ],
      ),
    );
  }
}

/// "● LIVE" tag next to section titles.
class LiveTag extends StatelessWidget {
  const LiveTag({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: colors.limeSoft, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.3, end: 1),
            duration: const Duration(milliseconds: 900),
            builder: (context, value, child) => Opacity(opacity: value, child: child),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 6),
          Text('LIVE', style: AppTextStyles.tag.copyWith(fontSize: 11, color: colors.accent, letterSpacing: 0.6)),
        ],
      ),
    );
  }
}
