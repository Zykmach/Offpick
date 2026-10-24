import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../services/clock_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';

enum CountdownStyle {
  /// Orange pill "02:14:36" (or grey "Ends in 2 days").
  pill,

  /// Orange pill "Ends in 02:14:36".
  pillWithPrefix,

  /// Icon + text without background, "2h 14m left".
  inline,

  /// Plain text, "Ends in 5h 20m".
  text,
}

/// Live countdown for an offer. Turns orange when less than a day is left.
class CountdownBadge extends StatelessWidget {
  final DateTime endsAt;
  final CountdownStyle style;
  final double fontSize;

  const CountdownBadge({
    super.key,
    required this.endsAt,
    this.style = CountdownStyle.pill,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<ClockService>(
      builder: (context, clock, child) {
        final remaining = clock.remainingUntil(endsAt);
        final isUrgent = remaining.inHours < 24;
        final color = isUrgent ? colors.warning : colors.textSecondary;
        final textStyle = AppTextStyles.bodyMedium.copyWith(
          fontSize: fontSize,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

        if (style == CountdownStyle.text) {
          return Text(Formatters.endsIn(remaining), style: textStyle);
        }

        String label;
        if (style == CountdownStyle.inline) {
          label = isUrgent ? Formatters.timeLeft(remaining) : Formatters.endsLabel(endsAt, clock.now);
        } else if (!isUrgent) {
          label = Formatters.endsLabel(endsAt, clock.now);
        } else if (style == CountdownStyle.pillWithPrefix) {
          label = 'Ends in ${Formatters.clock(remaining)}';
        } else {
          label = Formatters.clock(remaining);
        }

        final content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.clock, size: fontSize + 1, color: color),
            const SizedBox(width: 6),
            Flexible(child: Text(label, style: textStyle, overflow: TextOverflow.ellipsis)),
          ],
        );

        if (style == CountdownStyle.inline) return content;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: fontSize * 0.9, vertical: fontSize * 0.45),
          decoration: BoxDecoration(
            color: isUrgent ? colors.warningSoft : colors.surfaceMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: content,
        );
      },
    );
  }
}
