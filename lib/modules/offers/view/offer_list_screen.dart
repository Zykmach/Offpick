import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/badges.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../alerts/model/alert_target_option.dart';
import '../../alerts/view/set_alert_sheet.dart';
import '../controller/offer_list_controller.dart';
import '../model/offer_filter_model.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/offer_list_tile.dart';

class OfferListScreen extends StatelessWidget {
  const OfferListScreen({super.key});

  static const List<OfferSort> quickSorts = [OfferSort.newest, OfferSort.biggestDiscount, OfferSort.endingSoon];

  Future<void> openFilters(BuildContext context, OfferListController controller) async {
    final filter = await showFilterSheet(context, current: controller.filter, stores: controller.stores);
    if (filter != null) controller.applyFilter(filter);
  }

  void setAlert(BuildContext context, OfferListController controller) {
    final subcategory = controller.subcategory;
    final args = controller.args;
    final option = subcategory != null
        ? AlertTargetOption.forSubcategory(subcategory, controller.categoryName)
        : AlertTargetOption.forCategory(
            categoryId: args.categoryId ?? 'all',
            groupId: args.groupId,
            name: controller.title,
            iconKey: 'grid',
            tint: 'green',
          );
    openSetAlert(context, [option]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Consumer<OfferListController>(
          builder: (context, controller, child) {
            final offers = controller.visibleOffers;
            final filterCount = controller.filter.activeCount;

            return Column(
              children: [
                ScreenHeader(
                  title: controller.title,
                  subtitle: controller.isLoading ? 'Loading offers...' : '${controller.liveCount} live offers · updated just now',
                  trailing: CircleIconButton(
                    icon: LucideIcons.bellPlus,
                    onTap: () => setAlert(context, controller),
                    badge: const ProTag(lime: true, fontSize: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 14),
                  child: ChipScroller(
                    children: [
                      PillChip(
                        label: filterCount > 0 ? 'Filters · $filterCount' : 'Filters',
                        icon: LucideIcons.slidersHorizontal,
                        onTap: () => openFilters(context, controller),
                      ),
                      for (final sort in quickSorts)
                        PillChip(
                          label: sort.label,
                          selected: controller.filter.sort == sort,
                          onTap: () => controller.setSort(sort),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const AppLoader()
                      : offers.isEmpty
                          ? EmptyState(
                              icon: LucideIcons.tag,
                              title: controller.errorMessage ?? 'No live offers right now',
                              message: 'Set an alert and we will tell you when a new one starts.',
                            )
                          : RefreshIndicator(
                              color: colors.accent,
                              onRefresh: controller.refresh,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: offers.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 14),
                                itemBuilder: (context, index) => FadeSlideIn(
                                  key: ValueKey('${controller.filter.sort}-${offers[index].id}'),
                                  index: index,
                                  child: OfferListTile(offer: offers[index]),
                                ),
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
