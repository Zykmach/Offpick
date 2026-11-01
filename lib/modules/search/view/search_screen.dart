import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/pressable.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/route_arguments.dart';
import '../../categories/controller/categories_controller.dart';
import '../../offers/view/offer_actions.dart';
import '../controller/search_screen_controller.dart';
import 'widgets/search_sections.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  Future<void> runSearch(BuildContext context, SearchScreenController controller, String value) async {
    final query = await controller.submit(value);
    if (query != null && context.mounted) {
      Navigator.of(context).pushNamed(AppRoutes.searchResults, arguments: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchScreenController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.textController,
                          autofocus: true,
                          hint: 'Search products or brands',
                          prefixIcon: LucideIcons.search,
                          radius: 22,
                          textInputAction: TextInputAction.search,
                          onChanged: controller.onQueryChanged,
                          onSubmitted: (value) => runSearch(context, controller, value),
                          suffix: controller.isTyping
                              ? IconButton(
                                  onPressed: controller.clearText,
                                  icon: Icon(LucideIcons.x, size: 18, color: colors.textSecondary),
                                )
                              : null,
                        ),
                      ),
                      Pressable(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Text('Cancel', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: controller.isTyping
                        ? ListView(
                            key: const ValueKey('suggestions'),
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                            children: [
                              SearchSuggestions(
                                offers: controller.suggestions,
                                onTap: (offer) => OfferActions.openDetails(context, offer),
                              ),
                            ],
                          )
                        : ListView(
                            key: const ValueKey('discover'),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            children: [
                              if (controller.recent.isNotEmpty) ...[
                                SearchSectionTitle(
                                  'Recent',
                                  trailing: Pressable(
                                    onTap: controller.clearRecent,
                                    child: Text('Clear', style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary)),
                                  ),
                                ),
                                RecentSearches(
                                  items: controller.recent,
                                  onTap: (item) => runSearch(context, controller, item),
                                ),
                              ],
                              const SearchSectionTitle('Trending offers'),
                              TrendingList(
                                items: controller.trending,
                                onTap: (item) => runSearch(context, controller, item.query),
                              ),
                              const SearchSectionTitle('Browse by category'),
                              Consumer<CategoriesController>(
                                builder: (context, categories, child) => CategoryShortcuts(
                                  categories: categories.categories,
                                  onTap: (category) => Navigator.of(context).pushNamed(
                                    AppRoutes.categoryDetail,
                                    arguments: CategoryArgs(categoryId: category.id),
                                  ),
                                ),
                              ),
                            ],
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
