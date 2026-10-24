import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'pressable.dart';

enum AppButtonType { primary, outline, dark, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final Widget? leading;
  final IconData? trailingIcon;
  final Widget? badge;
  final bool isLoading;
  final bool expand;
  final double height;
  final double radius;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.leading,
    this.trailingIcon,
    this.badge,
    this.isLoading = false,
    this.expand = true,
    this.height = 56,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = onPressed != null && !isLoading;

    Color background = AppColors.lime;
    Color foreground = AppColors.onLime;
    Color borderColor = Colors.transparent;

    if (type == AppButtonType.outline) {
      background = colors.surface;
      foreground = colors.textPrimary;
      borderColor = colors.border;
    } else if (type == AppButtonType.dark) {
      background = colors.inverse;
      foreground = colors.onInverse;
    } else if (type == AppButtonType.text) {
      background = Colors.transparent;
      foreground = colors.textPrimary;
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        if (icon != null) ...[
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.button.copyWith(color: foreground),
          ),
        ),
        if (badge != null) ...[const SizedBox(width: 8), badge!],
        if (trailingIcon != null) ...[
          const SizedBox(width: 10),
          Icon(trailingIcon, size: 20, color: foreground),
        ],
      ],
    );

    return Pressable(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedOpacity(
        opacity: onPressed == null ? 0.45 : 1,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: height,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: foreground),
                    )
                  : KeyedSubtree(key: const ValueKey('content'), child: content),
            ),
          ),
        ),
      ),
    );
  }
}
