import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/form_controls.dart';
import '../../model/alert_trigger.dart';

/// One row in the "What do you want?" list.
class TriggerOptionTile extends StatelessWidget {
  final AlertTrigger trigger;
  final bool selected;
  final bool forProduct;
  final bool showDivider;
  final VoidCallback onTap;

  const TriggerOptionTile({
    super.key,
    required this.trigger,
    required this.selected,
    required this.forProduct,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final description = trigger.description(forProduct: forProduct);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? colors.limeSoft : colors.surface,
          border: showDivider ? Border(bottom: BorderSide(color: colors.border)) : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? AppColors.lime : colors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(trigger.icon, size: 20, color: selected ? AppColors.onLime : colors.textPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trigger.label, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 17)),
                  if (description != null)
                    Text(description, style: AppTextStyles.caption.copyWith(fontSize: 14, color: colors.textSecondary)),
                ],
              ),
            ),
            AppCheckbox(value: selected),
          ],
        ),
      ),
    );
  }
}
