import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/pressable.dart';
import '../../../routes/app_routes.dart';
import '../../home/controller/home_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/interests_controller.dart';
import 'widgets/interest_tile.dart';

class InterestsScreen extends StatelessWidget {
  const InterestsScreen({super.key});

  Future<void> save(BuildContext context, InterestsController controller) async {
    await controller.save();
    if (!context.mounted) return;
    context.read<HomeController>().reloadInterests();
    context.read<ProfileController>().refreshCounts();
    if (controller.isEditing) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.main, (oldRoute) => false);
    }
  }

  Future<void> skip(BuildContext context, InterestsController controller) async {
    await controller.skip();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.main, (oldRoute) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      body: SafeArea(
        child: Consumer<InterestsController>(
          builder: (context, controller, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
                  child: Row(
                    children: [
                      if (canGoBack)
                        CircleIconButton(icon: LucideIcons.chevronLeft, onTap: () => Navigator.of(context).pop()),
                      const Spacer(),
                      if (!controller.isEditing)
                        Pressable(
                          onTap: () => skip(context, controller),
                          child: Text(
                            'Skip',
                            style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15, color: colors.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const AppLoader()
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          children: [
                            FadeSlideIn(child: Text('What do you shop for?', style: AppTextStyles.heading1)),
                            const SizedBox(height: 10),
                            FadeSlideIn(
                              index: 1,
                              child: Text(
                                "We'll put these offers first in your feed. Change anytime.",
                                style: AppTextStyles.body.copyWith(fontSize: 14, color: colors.textSecondary),
                              ),
                            ),
                            const SizedBox(height: 24),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.interests.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: Responsive.tileRatio(context, 1.85),
                              ),
                              itemBuilder: (context, index) {
                                final interest = controller.interests[index];
                                return FadeSlideIn(
                                  index: index + 2,
                                  child: InterestTile(
                                    label: interest.label,
                                    iconKey: interest.iconKey,
                                    selected: controller.selectedInterestIds.contains(interest.id),
                                    onTap: () => controller.toggleInterest(interest.id),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'Stores you shop on',
                              style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: colors.textSecondary),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final store in controller.stores)
                                  PillChip(
                                    label: store.name,
                                    style: PillChipStyle.outline,
                                    height: 48,
                                    selected: controller.selectedStoreIds.contains(store.id),
                                    onTap: () => controller.toggleStore(store.id),
                                  ),
                              ],
                            ),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: AppButton(
                      key: ValueKey(controller.buttonLabel),
                      label: controller.buttonLabel,
                      isLoading: controller.isSaving,
                      onPressed: controller.canContinue ? () => save(context, controller) : null,
                    ),
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
