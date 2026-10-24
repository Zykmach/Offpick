import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'pressable.dart';

/// Round button with a border, used for back, search, bell, share etc.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final bool filled;
  final bool showDot;
  final Color? background;
  final Color? iconColor;
  final Widget? badge;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 52,
    this.iconSize = 22,
    this.filled = false,
    this.showDot = false,
    this.background,
    this.iconColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = background ?? (filled ? colors.inverse : colors.surface);
    final foreground = iconColor ?? (filled ? colors.onInverse : colors.textPrimary);

    return Pressable(
      onTap: onTap,
      pressedScale: 0.9,
      child: SizedBox(
        width: size + 8,
        height: size + 8,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: filled || background != null ? null : Border.all(color: colors.border),
              ),
              child: Icon(icon, size: iconSize, color: foreground),
            ),
            if (showDot)
              Positioned(
                top: size * 0.26,
                right: size * 0.3,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(color: colors.warning, borderRadius: BorderRadius.circular(3)),
                ),
              ),
            if (badge != null) Positioned(bottom: 0, right: 0, child: badge!),
          ],
        ),
      ),
    );
  }
}
