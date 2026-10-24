import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/badges.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../alerts/controller/alerts_controller.dart';
import '../../main_shell/controller/main_shell_controller.dart';
import '../controller/home_controller.dart';
import '../model/home_chip_model.dart';
import 'widgets/home_header.dart';
import 'widgets/home_offer_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openSearch(BuildContext context) => Navigator.of(context).pushNamed(AppRoutes.search);

  void openAlerts(BuildContext context) {
    context.read<AlertsController>().setTab(0);
    context.read<MainShellController>().setTab(MainShellController.alertsTab);
  }

  void seeAll(BuildContext context, HomeController controller) {
    final chip = controller.selectedChipId;
    final isCategory = chip != HomeChipModel.forYou;
    Navigator.of(context).pushNamed(
      AppRoutes.offerList,
      arguments: OfferListArgs(categoryId: isCategory ? chip : null, title: isCategory ? null : 'New offers'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          final feed = controller.feed;

          return RefreshIndicator(
            color: colors.accent,
            backgroundColor: colors.surface,
            onRefresh: controller.refresh,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: Consumer<AlertsController>(
                    builder: (context, alerts, child) => HomeHeader(
                      hasUnread: alerts.unreadCount > 0,
                      onBellTap: () => openAlerts(context),
                      onSearchTap: () => openSearch(context),
                      onFilterTap: () => openSearch(context),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 20),
                    child: ChipScroller(
                      children: [
                        for (final chip in controller.chips)
                          PillChip(
                            label: chip.label,
                            selected: chip.id == controller.selectedChipId,
                            onTap: () => controller.selectChip(chip.id),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'New offers',
                      titleTrailing: const LiveTag(),
                      actionLabel: 'See all',
                      onAction: () => seeAll(context, controller),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                if (controller.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [SkeletonBox(height: 420, radius: 26), SizedBox(height: 16), SkeletonBox(height: 200, radius: 26)],
                      ),
                    ),
                  )
                else if (controller.errorMessage != null && feed.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: LucideIcons.wifiOff,
                      title: "Couldn't load offers",
                      message: controller.errorMessage!,
                      action: AppButton(label: 'Try again', expand: false, onPressed: controller.refresh),
                    ),
                  )
                else if (feed.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: LucideIcons.tag,
                      title: 'No live offers here yet',
                      message: 'Pull down to refresh or try another category.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.separated(
                      itemCount: feed.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final offer = feed[index];
                        return FadeSlideIn(
                          key: ValueKey('${controller.selectedChipId}-${offer.id}'),
                          index: index,
                          child: HomeOfferCard(offer: offer),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
