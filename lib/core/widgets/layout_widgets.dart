import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'circle_icon_button.dart';
import 'pressable.dart';

/// White rounded card with a thin border.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 26,
    this.color,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? colors.border, width: 1.2),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: child,
    );
    return Pressable(onTap: onTap, pressedScale: 0.98, child: card);
  }
}

/// Title on the left and an optional action on the right.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? titleTrailing;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? actionColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.titleTrailing,
    this.actionLabel,
    this.onAction,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Flexible(
          child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.heading3),
        ),
        if (titleTrailing != null) ...[const SizedBox(width: 10), titleTrailing!],
        const Spacer(),
        if (actionLabel != null)
          Pressable(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.bodySemiBold.copyWith(color: actionColor ?? colors.accent, fontSize: 14),
            ),
          ),
      ],
    );
  }
}

/// Back button, title and an optional subtitle / trailing button.
class ScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;

  const ScreenHeader({super.key, required this.title, this.subtitle, this.trailing, this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          CircleIconButton(icon: LucideIcons.chevronLeft, onTap: onBack ?? () => Navigator.of(context).maybePop()),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.heading2),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.bodyMedium.copyWith(color: colors.accent)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Price in bold with the old price struck through next to it.
class PriceRow extends StatelessWidget {
  final int price;
  final int mrp;
  final TextStyle priceStyle;
  final double mrpSize;

  const PriceRow({super.key, required this.price, required this.mrp, required this.priceStyle, this.mrpSize = 15});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Shrinks big prices (₹1,24,999) instead of running off the card.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(Formatters.price(price), style: priceStyle),
          const SizedBox(width: 8),
          Text(
            Formatters.price(mrp),
            style: AppTextStyles.body.copyWith(
              fontSize: mrpSize,
              color: colors.textMuted,
              decoration: TextDecoration.lineThrough,
              decorationColor: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon in a circle, a title, a message and an optional action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(color: colors.limeSoft, shape: BoxShape.circle),
              child: Icon(icon, size: 34, color: colors.accent),
            ),
            const SizedBox(height: 20),
            Text(title, textAlign: TextAlign.center, style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// A full-screen column that fills the height (so Spacers work) and scrolls
/// instead of overflowing on short phones or with large text.
class FillOrScroll extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const FillOrScroll({super.key, this.padding = EdgeInsets.zero, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: (constraints.maxHeight - padding.vertical).clamp(0, double.infinity)),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
