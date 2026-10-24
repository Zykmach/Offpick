import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/badges.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../routes/app_routes.dart';
import '../../pro/controller/pro_controller.dart';
import '../controller/compare_controller.dart';
import 'widgets/tracked_product_card.dart';

/// The Compare tab: every product the user has compared.
class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Consumer2<CompareController, ProController>(
        builder: (context, controller, pro, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                child: Row(
                  children: [
                    Text('Compare', style: AppTextStyles.display),
                    const SizedBox(width: 12),
                    const CrownTag(),
                    const Spacer(),
                    if (pro.isPro)
                      CircleIconButton(
                        icon: LucideIcons.plus,
                        filled: true,
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Text(
                  "Products you're tracking across stores. Prices refresh automatically.",
                  style: AppTextStyles.body.copyWith(fontSize: 16, color: colors.textSecondary),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: !pro.isPro
                      ? EmptyState(
                          key: const ValueKey('locked'),
                          icon: LucideIcons.lockKeyhole,
                          title: 'Compare is a Pro feature',
                          message: 'See the same product on every store and buy where it is cheapest.',
                          action: AppButton(
                            label: 'Unlock with Pro',
                            icon: LucideIcons.crown,
                            expand: false,
                            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.paywall),
                          ),
                        )
                      : controller.isLoading
                          ? const AppLoader()
                          : controller.comparisons.isEmpty
                              ? EmptyState(
                                  key: const ValueKey('empty'),
                                  icon: LucideIcons.arrowLeftRight,
                                  title: 'Nothing tracked yet',
                                  message: 'Tap Compare on any offer to see it on every store.',
                                  action: AppButton(
                                    label: 'Find a product',
                                    expand: false,
                                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.search),
                                  ),
                                )
                              : RefreshIndicator(
                                  key: const ValueKey('list'),
                                  color: colors.accent,
                                  onRefresh: controller.load,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.comparisons.length + 1,
                                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return FadeSlideIn(child: SavingsBanner(amount: controller.totalSaved));
                                      }
                                      final comparison = controller.comparisons[index - 1];
                                      return FadeSlideIn(
                                        index: index,
                                        child: Dismissible(
                                          key: ValueKey(comparison.offerId),
                                          direction: DismissDirection.endToStart,
                                          onDismissed: (direction) => controller.remove(comparison.offerId),
                                          background: Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(right: 24),
                                            decoration: BoxDecoration(
                                              color: colors.warningSoft,
                                              borderRadius: BorderRadius.circular(26),
                                            ),
                                            child: Icon(LucideIcons.trash2, color: colors.warning),
                                          ),
                                          child: TrackedProductCard(
                                            comparison: comparison,
                                            onTap: () => Navigator.of(context).pushNamed(
                                              AppRoutes.comparePrices,
                                              arguments: comparison.offerId,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
