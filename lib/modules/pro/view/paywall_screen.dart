import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/badges.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/feature_row.dart';
import '../../../core/widgets/pressable.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/pro_controller.dart';
import '../model/plan_model.dart';
import 'widgets/paywall_widgets.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  Future<void> purchase(BuildContext context, ProController controller) async {
    final success = await controller.purchase();
    if (!context.mounted) return;
    if (success) {
      AppMessages.show(context, 'Welcome to Offpick Pro');
      Navigator.of(context).pop(true);
    } else if (controller.errorMessage != null) {
      AppMessages.show(context, controller.errorMessage!);
    }
  }

  Future<void> restore(BuildContext context, ProController controller) async {
    final success = await controller.restore();
    if (!context.mounted) return;
    if (success) {
      AppMessages.show(context, 'Your Pro plan is back');
      Navigator.of(context).pop(true);
    } else {
      AppMessages.show(context, 'No earlier purchase found on this account');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final linkStyle = AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: colors.textSecondary);

    return Scaffold(
      body: SafeArea(
        child: Consumer<ProController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: CircleIconButton(
                      icon: LucideIcons.x,
                      background: colors.surfaceMuted,
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    children: [
                      FadeSlideIn(
                        child: Row(
                          children: [
                            const AppLogoMark(size: 64),
                            const SizedBox(width: 8),
                            const CrownTag(label: 'OFFPICK PRO'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeSlideIn(
                        index: 1,
                        child: Text(
                          controller.isPro ? "You're on Pro" : 'Pay the lowest price, every time',
                          style: AppTextStyles.display,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        index: 2,
                        child: Text(
                          'Browsing offers and visiting stores is always free. Pro adds the tools that save you more.',
                          style: AppTextStyles.body.copyWith(fontSize: 15, color: colors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const FadeSlideIn(
                        index: 3,
                        child: FeatureRow(
                          icon: LucideIcons.arrowLeftRight,
                          title: 'Compare across stores',
                          message: 'Same product, every store, best price first',
                        ),
                      ),
                      const FadeSlideIn(
                        index: 4,
                        child: FeatureRow(
                          icon: LucideIcons.bell,
                          title: 'Smart alerts',
                          message: 'New offers, price drops and discount thresholds',
                        ),
                      ),
                      const FadeSlideIn(
                        index: 5,
                        child: FeatureRow(
                          icon: LucideIcons.clock,
                          title: 'Ending-soon reminders',
                          message: 'A nudge before a deal you like expires',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Column(
                    children: [
                      if (!controller.isPro) ...[
                        PlanOptionCard(
                          plan: PlanModel.yearly,
                          bestValue: true,
                          selected: controller.selectedPlan == PlanModel.yearly,
                          onTap: () => controller.selectPlan(PlanModel.yearly),
                        ),
                        const SizedBox(height: 14),
                        PlanOptionCard(
                          plan: PlanModel.monthly,
                          selected: controller.selectedPlan == PlanModel.monthly,
                          onTap: () => controller.selectPlan(PlanModel.monthly),
                        ),
                        const SizedBox(height: 18),
                      ],
                      AppButton(
                        label: controller.isPro ? 'Done' : 'Get Pro',
                        isLoading: controller.isPurchasing,
                        onPressed: controller.isPro
                            ? () => Navigator.of(context).pop(true)
                            : () => purchase(context, controller),
                      ),
                      const SizedBox(height: 14),
                      Consumer<ProfileController>(
                        builder: (context, profile, child) => Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 24,
                          runSpacing: 8,
                          children: [
                            Pressable(
                              onTap: controller.isRestoring ? null : () => restore(context, controller),
                              child: Text(controller.isRestoring ? 'Restoring...' : 'Restore purchase', style: linkStyle),
                            ),
                            Pressable(onTap: profile.openTerms, child: Text('Terms', style: linkStyle)),
                            Pressable(onTap: profile.openPrivacy, child: Text('Privacy', style: linkStyle)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
