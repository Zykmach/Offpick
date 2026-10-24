import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../routes/app_routes.dart';
import '../../main_shell/controller/main_shell_controller.dart';
import '../controller/alerts_controller.dart';
import '../model/alert_model.dart';
import '../model/alert_target_option.dart';
import '../model/notification_model.dart';
import 'set_alert_sheet.dart';
import 'widgets/alert_cards.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  void openNotification(BuildContext context, AlertsController controller, NotificationModel notification) {
    controller.markRead(notification.id);
    if (notification.offerId != null) {
      Navigator.of(context).pushNamed(AppRoutes.productDetails, arguments: notification.offerId);
    }
  }

  void addAlert(BuildContext context) {
    context.read<MainShellController>().setTab(MainShellController.categoriesTab);
    AppMessages.show(context, 'Pick a category or product, then tap Set alert');
  }

  Future<void> deleteAlert(BuildContext context, AlertsController controller, AlertModel alert) async {
    final confirmed = await AppMessages.confirm(
      context,
      title: 'Delete alert?',
      message: 'You will stop getting notifications for ${alert.title}.',
      confirmLabel: 'Delete',
    );
    if (confirmed) controller.deleteAlert(alert.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Consumer<AlertsController>(
        builder: (context, controller, child) {
          final showNotifications = controller.tabIndex == 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Alerts', style: AppTextStyles.display),
                      const Spacer(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: showNotifications
                            ? Pressable(
                                key: const ValueKey('mark-read'),
                                onTap: controller.unreadCount > 0 ? controller.markAllRead : null,
                                child: Text(
                                  'Mark all read',
                                  style: AppTextStyles.bodySemiBold.copyWith(
                                    fontSize: 17,
                                    color: controller.unreadCount > 0 ? colors.accent : colors.textMuted,
                                  ),
                                ),
                              )
                            : CircleIconButton(
                                key: const ValueKey('add'),
                                icon: LucideIcons.plus,
                                filled: true,
                                onTap: () => addAlert(context),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SegmentedTabs(
                  labels: const ['Notifications', 'My alerts'],
                  badges: [null, controller.activeCount],
                  selectedIndex: controller.tabIndex,
                  onChanged: controller.setTab,
                  height: 58,
                ),
              ),
              Expanded(
                child: controller.isLoading
                    ? const AppLoader()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: showNotifications
                            ? NotificationsList(
                                key: const ValueKey('notifications'),
                                groups: controller.groupedNotifications,
                                onTap: (item) => openNotification(context, controller, item),
                                onDismiss: (item) => controller.deleteNotification(item.id),
                              )
                            : MyAlertsList(
                                key: const ValueKey('alerts'),
                                alerts: controller.alerts,
                                onToggle: controller.toggleAlert,
                                onTap: (alert) => openSetAlert(
                                  context,
                                  [AlertTargetOption.fromAlert(alert)],
                                  showConfirmation: false,
                                ),
                                onLongPress: (alert) => deleteAlert(context, controller, alert),
                              ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NotificationsList extends StatelessWidget {
  final Map<String, List<NotificationModel>> groups;
  final ValueChanged<NotificationModel> onTap;
  final ValueChanged<NotificationModel> onDismiss;

  const NotificationsList({super.key, required this.groups, required this.onTap, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (groups.isEmpty) {
      return const EmptyState(
        icon: LucideIcons.bellOff,
        title: 'No notifications yet',
        message: 'Set an alert and we will tell you the moment a deal matches.',
      );
    }

    var index = 0;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 12),
            child: Text(entry.key, style: AppTextStyles.label.copyWith(fontSize: 14, color: colors.textSecondary)),
          ),
          for (final item in entry.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FadeSlideIn(
                index: index++,
                child: Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => onDismiss(item),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(color: colors.warningSoft, borderRadius: BorderRadius.circular(26)),
                    child: Icon(LucideIcons.trash2, color: colors.warning),
                  ),
                  child: NotificationCard(notification: item, onTap: () => onTap(item)),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class MyAlertsList extends StatelessWidget {
  final List<AlertModel> alerts;
  final void Function(String id, bool isActive) onToggle;
  final ValueChanged<AlertModel> onTap;
  final ValueChanged<AlertModel> onLongPress;

  const MyAlertsList({
    super.key,
    required this.alerts,
    required this.onToggle,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const EmptyState(
        icon: LucideIcons.bellPlus,
        title: 'No alerts yet',
        message: 'Open a product or category and tap Set alert.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      itemCount: alerts.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        if (index == alerts.length) {
          return Text(
            'Tap an alert to edit it, long press to delete.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: context.colors.textMuted),
          );
        }
        final alert = alerts[index];
        return FadeSlideIn(
          index: index,
          child: AlertCard(
            alert: alert,
            onToggle: (value) => onToggle(alert.id, value),
            onTap: () => onTap(alert),
            onLongPress: () => onLongPress(alert),
          ),
        );
      },
    );
  }
}
