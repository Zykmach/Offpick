import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// Lime toggle with a dark knob, as in "My alerts".
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 60,
        height: 34,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.lime : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: value ? AppColors.onLime : colors.surface,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Square check box. Lime with a dark tick when checked.
class AppCheckbox extends StatelessWidget {
  final bool value;
  final double size;

  const AppCheckbox({super.key, required this.value, this.size = 26});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value ? AppColors.lime : colors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: value ? AppColors.lime : colors.textMuted, width: 1.4),
      ),
      child: AnimatedScale(
        scale: value ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        child: Icon(LucideIcons.check, size: size * 0.8, color: AppColors.onLime),
      ),
    );
  }
}

/// Round radio button used for plan selection.
class AppRadio extends StatelessWidget {
  final bool selected;

  const AppRadio({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: selected ? AppColors.lime : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: selected ? AppColors.lime : colors.border, width: 2),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        scale: selected ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(color: AppColors.onLime, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/// Dots under a page view. The active one stretches into a pill.
class PageDots extends StatelessWidget {
  final int count;
  final int current;
  final Color? activeColor;

  const PageDots({super.key, required this.count, required this.current, this.activeColor});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(right: 6),
          width: isActive ? 28 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? (activeColor ?? colors.textPrimary) : colors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Thin rounded progress bar with a lime fill.
class AppProgressBar extends StatelessWidget {
  final double value;
  final double width;
  final Duration duration;

  const AppProgressBar({
    super.key,
    required this.value,
    this.width = 120,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: width,
      height: 4,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        width: width * value.clamp(0, 1),
        decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}
