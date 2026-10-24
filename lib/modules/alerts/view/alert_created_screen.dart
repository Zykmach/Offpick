import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../main_shell/controller/main_shell_controller.dart';
import '../controller/alerts_controller.dart';
import '../model/alert_trigger.dart';

class AlertCreatedScreen extends StatelessWidget {
  final AlertCreatedArgs args;

  const AlertCreatedScreen({super.key, required this.args});

  void manageAlerts(BuildContext context) {
    context.read<AlertsController>().setTab(1);
    context.read<MainShellController>().setTab(MainShellController.alertsTab);
    Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.main));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final alert = args.alert;
    final firstTrigger = alert.triggers.isEmpty ? AlertTrigger.newOffer : alert.triggers.first;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            children: [
              const Spacer(),
              PopIn(
                from: 0.3,
                duration: const Duration(milliseconds: 900),
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(color: colors.limeSoft, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                    child: const Icon(LucideIcons.check, size: 44, color: AppColors.onLime),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeSlideIn(index: 2, child: Text('Your alert is on', style: AppTextStyles.heading1.copyWith(fontSize: 34))),
              const SizedBox(height: 10),
              FadeSlideIn(
                index: 3,
                child: Text(
                  "We'll notify you the moment\n${alert.title} matches.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(fontSize: 17, color: colors.textSecondary),
                ),
              ),
              const SizedBox(height: 22),
              FadeSlideIn(
                index: 4,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final trigger in alert.triggers)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(trigger.icon, size: 16),
                            const SizedBox(width: 8),
                            Text(trigger.label, style: AppTextStyles.bodySemiBold),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              FadeSlideIn(
                index: 5,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "YOU'LL GET A NOTIFICATION LIKE THIS",
                    style: AppTextStyles.label.copyWith(fontSize: 13, color: colors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeSlideIn(
                index: 6,
                child: NotificationPreview(title: firstTrigger.previewTitle(alert.title), body: args.previewBody),
              ),
              const Spacer(),
              AppButton(label: 'Back to deal', onPressed: () => Navigator.of(context).pop()),
              const SizedBox(height: 8),
              AppButton(label: 'Manage my alerts', type: AppButtonType.text, onPressed: () => manageAlerts(context)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fake lock-screen notification so users know what to expect.
class NotificationPreview extends StatelessWidget {
  final String title;
  final String body;

  const NotificationPreview({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.border),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: const Color(0xFF0F1510), borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: const AppLogoMark(size: 38),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Offpick', style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
                    const Spacer(),
                    Text('now', style: AppTextStyles.caption.copyWith(fontSize: 14, color: colors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(body, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
