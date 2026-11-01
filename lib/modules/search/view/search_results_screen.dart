import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../offers/model/offer_filter_model.dart';
import '../../offers/view/widgets/filter_sheet.dart';
import '../../offers/view/widgets/offer_grid_card.dart';
import '../controller/search_results_controller.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  Future<void> openFilters(BuildContext context, SearchResultsController controller) async {
    final filter = await showFilterSheet(context, current: controller.filter, stores: controller.stores);
    if (filter != null) controller.applyFilter(filter);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchResultsController>(
          builder: (context, controller, child) {
            final results = controller.visibleResults;
            final filterCount = controller.filter.activeCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 20, 0),
                  child: Row(
                    children: [
                      CircleIconButton(icon: LucideIcons.chevronLeft, onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: controller.textController,
                          prefixIcon: LucideIcons.search,
                          radius: 26,
                          textInputAction: TextInputAction.search,
                          onSubmitted: controller.search,
                          suffix: IconButton(
                            onPressed: controller.textController.clear,
                            icon: CircleAvatar(
                              radius: 14,
                              backgroundColor: colors.surfaceMuted,
                              child: Icon(LucideIcons.x, size: 16, color: colors.textPrimary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.foundIn.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: ChipScroller(
                      children: [
                        Text('In:', style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: colors.textSecondary)),
                        for (final subcategory in controller.foundIn)
                          PillChip(
                            label: controller.pathFor(subcategory),
                            style: PillChipStyle.tinted,
                            height: 38,
                            selected: controller.selectedSubcategoryId == subcategory.id,
                            onTap: () => controller.selectSubcategory(subcategory.id),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: ChipScroller(
                    children: [
                      PillChip(
                        label: filterCount > 0 ? 'Filters · $filterCount' : 'Filters',
                        icon: LucideIcons.slidersHorizontal,
                        onTap: () => openFilters(context, controller),
                      ),
                      PillChip(
                        label: 'Newest',
                        selected: controller.filter.sort == OfferSort.newest,
                        onTap: () => controller.setSort(OfferSort.newest),
                      ),
                      PillChip(
                        label: '30%+ off',
                        selected: controller.onlyBigDiscounts,
                        onTap: controller.toggleBigDiscounts,
                      ),
                      PillChip(
                        label: 'Ending soon',
                        selected: controller.filter.sort == OfferSort.endingSoon,
                        onTap: () => controller.setSort(OfferSort.endingSoon),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      controller.isLoading ? 'Searching...' : '${results.length} live offers for “${controller.query}”',
                      key: ValueKey('${results.length}-${controller.query}-${controller.isLoading}'),
                      style: AppTextStyles.body.copyWith(fontSize: 14, color: colors.textSecondary),
                    ),
                  ),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const AppLoader()
                      : results.isEmpty
                          ? const EmptyState(
                              icon: LucideIcons.searchX,
                              title: 'No live offers found',
                              message: 'Try another word or remove some filters.',
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: results.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 22,
                                crossAxisSpacing: 14,
                                childAspectRatio: Responsive.tileRatio(context, 0.54),
                              ),
                              itemBuilder: (context, index) => FadeSlideIn(
                                key: ValueKey('${controller.filter.sort}-${results[index].id}'),
                                index: index,
                                child: OfferGridCard(offer: results[index]),
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
