import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../alerts/model/alert_target_option.dart';
import '../../alerts/view/set_alert_sheet.dart';
import '../controller/category_detail_controller.dart';
import 'widgets/subcategory_tile.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  void setAlert(BuildContext context, CategoryDetailController controller) {
    final category = controller.category!;
    openSetAlert(context, [
      AlertTargetOption.forCategory(
        categoryId: category.id,
        groupId: controller.groupId,
        name: controller.alertName,
        iconKey: category.iconKey,
        tint: category.tint,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CategoryDetailController>(
          builder: (context, controller, child) {
            final category = controller.category;
            if (controller.isLoading) return const AppLoader();
            if (category == null) {
              return const EmptyState(icon: LucideIcons.layoutGrid, title: 'Category not found', message: 'Go back and pick another one.');
            }

            final subcategories = controller.subcategories;
            return Column(
              children: [
                ScreenHeader(
                  title: category.name,
                  trailing: CircleIconButton(
                    icon: LucideIcons.search,
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      if (category.hasGroups) ...[
                        SegmentedTabs(
                          labels: controller.groupLabels,
                          selectedIndex: controller.groupIndex,
                          onChanged: controller.setGroup,
                          height: 58,
                        ),
                        const SizedBox(height: 26),
                      ],
                      Text('Shop by product', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: GridView.builder(
                          key: ValueKey(controller.groupId),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subcategories.length + 1,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.86,
                          ),
                          itemBuilder: (context, index) {
                            if (index == subcategories.length) {
                              return FadeSlideIn(
                                index: index,
                                child: SubcategoryTile(
                                  name: 'View all',
                                  iconKey: '',
                                  tint: '',
                                  isViewAll: true,
                                  offerCount: controller.totalOffers,
                                  onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.offerList,
                                    arguments: OfferListArgs(categoryId: category.id, groupId: controller.groupId),
                                  ),
                                ),
                              );
                            }
                            final subcategory = subcategories[index];
                            return FadeSlideIn(
                              index: index,
                              child: SubcategoryTile(
                                name: subcategory.name,
                                iconKey: subcategory.iconKey,
                                tint: subcategory.tint,
                                offerCount: subcategory.offerCount,
                                onTap: () => Navigator.of(context).pushNamed(
                                  AppRoutes.offerList,
                                  arguments: OfferListArgs(subcategoryId: subcategory.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      FadeSlideIn(
                        index: 6,
                        child: AlertBanner(name: controller.alertName, onSetAlert: () => setAlert(context, controller)),
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
