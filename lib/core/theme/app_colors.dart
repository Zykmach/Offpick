import 'package:flutter/material.dart';

/// Brand colors that stay the same in light and dark mode.
class AppColors {
  static const Color lime = Color(0xFFC6F432);
  static const Color onLime = Color(0xFF0F1510);
  static const Color logoYellow = Color(0xFFE6F23A);
  static const Color logoGreen = Color(0xFF2BC653);
}

/// Colors that change between light and dark mode.
/// Read them anywhere with `context.colors`.
class OffpickColors extends ThemeExtension<OffpickColors> {
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color limeSoft;
  final Color warning;
  final Color warningSoft;
  final Color inverse;
  final Color onInverse;
  final Color placeholderIcon;
  final Color tintGreen;
  final Color tintBlue;
  final Color tintPeach;
  final Color tintPink;
  final Color shadow;

  const OffpickColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.limeSoft,
    required this.warning,
    required this.warningSoft,
    required this.inverse,
    required this.onInverse,
    required this.placeholderIcon,
    required this.tintGreen,
    required this.tintBlue,
    required this.tintPeach,
    required this.tintPink,
    required this.shadow,
  });

  static const OffpickColors light = OffpickColors(
    background: Color(0xFFF5F7F2),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEEF1E9),
    border: Color(0xFFE3E8DD),
    textPrimary: Color(0xFF0F1510),
    textSecondary: Color(0xFF5B665C),
    textMuted: Color(0xFF8A958B),
    accent: Color(0xFF15803D),
    limeSoft: Color(0xFFECF7D6),
    warning: Color(0xFFC2410C),
    warningSoft: Color(0xFFFDEBDD),
    inverse: Color(0xFF0F1510),
    onInverse: Color(0xFFFFFFFF),
    placeholderIcon: Color(0xFF7E8C7A),
    tintGreen: Color(0xFFEBF0E2),
    tintBlue: Color(0xFFE5EBF3),
    tintPeach: Color(0xFFF4ECE3),
    tintPink: Color(0xFFF1E5EC),
    shadow: Color(0x140F1510),
  );

  static const OffpickColors dark = OffpickColors(
    background: Color(0xFF0B0E0B),
    surface: Color(0xFF151A16),
    surfaceMuted: Color(0xFF1F2620),
    border: Color(0xFF262D27),
    textPrimary: Color(0xFFF2F4EE),
    textSecondary: Color(0xFFA3AEA4),
    textMuted: Color(0xFF7A857B),
    accent: Color(0xFFA3E36F),
    limeSoft: Color(0xFF1C2914),
    warning: Color(0xFFFB923C),
    warningSoft: Color(0xFF3A2213),
    inverse: Color(0xFFF2F4EE),
    onInverse: Color(0xFF0F1510),
    placeholderIcon: Color(0xFF6F7D6B),
    tintGreen: Color(0xFF1A2219),
    tintBlue: Color(0xFF182029),
    tintPeach: Color(0xFF221D18),
    tintPink: Color(0xFF231A21),
    shadow: Color(0x00000000),
  );

  /// Soft background used behind product placeholders and category icons.
  Color tint(String name) {
    switch (name) {
      case 'blue':
        return tintBlue;
      case 'peach':
        return tintPeach;
      case 'pink':
        return tintPink;
      default:
        return tintGreen;
    }
  }

  @override
  OffpickColors copyWith() => this;

  @override
  OffpickColors lerp(OffpickColors? other, double t) {
    if (other == null) return this;
    return OffpickColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      limeSoft: Color.lerp(limeSoft, other.limeSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      inverse: Color.lerp(inverse, other.inverse, t)!,
      onInverse: Color.lerp(onInverse, other.onInverse, t)!,
      placeholderIcon: Color.lerp(placeholderIcon, other.placeholderIcon, t)!,
      tintGreen: Color.lerp(tintGreen, other.tintGreen, t)!,
      tintBlue: Color.lerp(tintBlue, other.tintBlue, t)!,
      tintPeach: Color.lerp(tintPeach, other.tintPeach, t)!,
      tintPink: Color.lerp(tintPink, other.tintPink, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  OffpickColors get colors => Theme.of(this).extension<OffpickColors>()!;
}
