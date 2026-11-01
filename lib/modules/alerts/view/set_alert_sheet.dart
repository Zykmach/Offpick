import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../pro/controller/pro_gate.dart';
import '../controller/set_alert_controller.dart';
import '../model/alert_model.dart';
import '../model/alert_target_option.dart';
import '../model/alert_trigger.dart';
import 'widgets/trigger_option_tile.dart';

/// Pro check, then the sheet, then the "Your alert is on" screen.
Future<void> openSetAlert(BuildContext context, List<AlertTargetOption> options, {bool showConfirmation = true}) {
  return ProGate.run(context, () async {
    final result = await showAppSheet<(AlertModel, String)>(
      context,
      builder: (sheetContext) => ChangeNotifierProvider(
        create: (context) => SetAlertController(alertsController: context.read(), options: options),
        child: const SetAlertSheet(),
      ),
    );
    if (result == null || !context.mounted || !showConfirmation) return;
    Navigator.of(context).pushNamed(
      AppRoutes.alertCreated,
      arguments: AlertCreatedArgs(alert: result.$1, previewBody: result.$2),
    );
  });
}

class SetAlertSheet extends StatelessWidget {
  const SetAlertSheet({super.key});

  Future<void> save(BuildContext context, SetAlertController controller) async {
    final alert = await controller.save();
    if (context.mounted) Navigator.of(context).pop((alert, controller.option.previewBody));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelStyle = AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: colors.textSecondary);

    return Consumer<SetAlertController>(
      builder: (context, controller, child) {
        return SheetLayout(
          title: 'Set an alert',
          footer: AppButton(
            label: controller.isEditing ? 'Update alert' : 'Create alert',
            icon: LucideIcons.bell,
            isLoading: controller.isSaving,
            onPressed: controller.canSave ? () => save(context, controller) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alert me about', style: labelStyle),
              const SizedBox(height: 12),
              if (controller.options.length > 1)
                SegmentedTabs(
                  labels: controller.options.map((item) => item.tabLabel).toList(),
                  selectedIndex: controller.optionIndex,
                  onChanged: controller.selectOption,
                )
              else
                Text(controller.option.title, style: AppTextStyles.heading3),
              const SizedBox(height: 22),
              Text.rich(
                TextSpan(
                  text: 'What do you want? ',
                  style: labelStyle,
                  children: [
                    TextSpan(text: 'Pick any', style: AppTextStyles.body.copyWith(fontSize: 14, color: colors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: colors.border, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      for (final trigger in AlertTrigger.values)
                        TriggerOptionTile(
                          trigger: trigger,
                          forProduct: controller.option.isProduct,
                          selected: controller.selected.contains(trigger),
                          showDivider: trigger != AlertTrigger.values.last,
                          onTap: () => controller.toggle(trigger),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
