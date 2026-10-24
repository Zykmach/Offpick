import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/badges.dart';
import '../../../../core/widgets/form_controls.dart';
import '../../../../core/widgets/layout_widgets.dart';
import '../../../../services/clock_service.dart';
import '../../model/alert_model.dart';
import '../../model/alert_trigger.dart';
import '../../model/notification_model.dart';

/// Coloured square icon for each notification type.
class NotificationIcon extends StatelessWidget {
  final AlertTrigger type;

  const NotificationIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Color background = colors.surfaceMuted;
    Color foreground = colors.textPrimary;

    if (type == AlertTrigger.newOffer) {
      background = AppColors.lime;
      foreground = AppColors.onLime;
    } else if (type == AlertTrigger.priceDrop) {
      background = colors.limeSoft;
      foreground = colors.accent;
    } else if (type == AlertTrigger.endingSoon) {
      background = colors.warningSoft;
      foreground = colors.warning;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(14)),
      child: Icon(type.icon, size: 22, color: foreground),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              NotificationIcon(type: notification.type),
              Positioned(
                left: -6,
                top: -6,
                child: AnimatedScale(
                  scale: notification.isRead ? 0 : 1,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: colors.warning, shape: BoxShape.circle),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(notification.title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 17))),
                    const SizedBox(width: 8),
                    Consumer<ClockService>(
                      builder: (context, clock, child) => Text(
                        Formatters.shortAgo(notification.createdAt, clock.now),
                        style: AppTextStyles.caption.copyWith(fontSize: 14, color: colors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notification.body, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onToggle,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onLongPress: onLongPress,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedOpacity(
                  opacity: alert.isActive ? 1 : 0.6,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: colors.tint(alert.tint), borderRadius: BorderRadius.circular(16)),
                    child: Center(child: AppIcon(alert.iconKey, size: 24, color: colors.textPrimary)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: alert.isActive ? 1 : 0.6,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert.title, style: AppTextStyles.title.copyWith(fontSize: 19)),
                        Text(alert.subtitle, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                AppSwitch(value: alert.isActive, onChanged: onToggle),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: alert.isActive && alert.triggers.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [for (final trigger in alert.triggers) InfoChip(label: trigger.label)],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
