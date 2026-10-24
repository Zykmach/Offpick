import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../controller/categories_controller.dart';
import 'widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void openCategory(BuildContext context, String categoryId, {String groupId = ''}) {
    Navigator.of(context).pushNamed(
      AppRoutes.categoryDetail,
      arguments: CategoryArgs(categoryId: categoryId, groupId: groupId),
    );
  }

  void openSubcategory(BuildContext context, String subcategoryId) {
    Navigator.of(context).pushNamed(AppRoutes.offerList, arguments: OfferListArgs(subcategoryId: subcategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Consumer<CategoriesController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                child: Row(
                  children: [
                    Text('Categories', style: AppTextStyles.display),
                    const Spacer(),
                    CircleIconButton(
                      icon: LucideIcons.search,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.isLoading
                    ? const AppLoader()
                    : controller.errorMessage != null
                        ? EmptyState(
                            icon: LucideIcons.wifiOff,
                            title: "Couldn't load categories",
                            message: controller.errorMessage!,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.categories.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final category = controller.categories[index];
                              return FadeSlideIn(
                                index: index,
                                child: CategoryCard(
                                  category: category,
                                  onTap: () => openCategory(context, category.id),
                                  onGroupTap: (groupId) => openCategory(context, category.id, groupId: groupId),
                                  onSubcategoryTap: (subcategory) => openSubcategory(context, subcategory.id),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
