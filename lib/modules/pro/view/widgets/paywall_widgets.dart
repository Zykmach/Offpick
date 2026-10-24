import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/form_controls.dart';
import '../../../../core/widgets/pressable.dart';
import '../../model/plan_model.dart';

/// Icon + title + one line of text describing a Pro feature.
class ProFeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const ProFeatureRow({super.key, required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: colors.limeSoft, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 22, color: colors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 17)),
                const SizedBox(height: 2),
                Text(message, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable plan with a radio, name and price.
class PlanOptionCard extends StatelessWidget {
  final PlanModel plan;
  final bool selected;
  final bool bestValue;
  final VoidCallback onTap;

  const PlanOptionCard({
    super.key,
    required this.plan,
    required this.selected,
    required this.onTap,
    this.bestValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: selected ? colors.limeSoft : colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: selected ? AppColors.lime : colors.border, width: selected ? 2.2 : 1.2),
            ),
            child: Row(
              children: [
                AppRadio(selected: selected),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 18)),
                      Text(plan.subtitle, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: '₹${plan.price}',
                    style: AppTextStyles.price,
                    children: [
                      TextSpan(
                        text: plan.period,
                        style: AppTextStyles.body.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (bestValue)
            Positioned(
              right: 18,
              top: -12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: colors.inverse, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'BEST VALUE',
                  style: AppTextStyles.label.copyWith(fontSize: 11, color: colors.onInverse),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
