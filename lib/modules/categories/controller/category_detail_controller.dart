import 'package:flutter/foundation.dart';

import '../../../repositories/catalog_repository.dart';
import '../model/category_model.dart';
import '../model/subcategory_model.dart';

/// Category page, e.g. Fashion with its Men / Women tabs.
class CategoryDetailController extends ChangeNotifier {
  final CatalogRepository repository;
  final String categoryId;

  CategoryModel? category;
  int groupIndex = 0;
  bool isLoading = true;

  CategoryDetailController({required this.repository, required this.categoryId, String initialGroup = ''}) {
    load(initialGroup);
  }

  String get groupId => category == null || !category!.hasGroups ? '' : category!.groups[groupIndex];

  /// "Men", "Women"
  List<String> get groupLabels {
    final groups = category?.groups ?? [];
    return groups.map((group) => group[0].toUpperCase() + group.substring(1)).toList();
  }

  List<SubcategoryModel> get subcategories => category?.subcategoriesFor(groupId) ?? [];

  int get totalOffers => category?.offersFor(groupId) ?? 0;

  /// "Men's fashion" / "Beauty", used in the alert banner.
  String get alertName {
    if (category == null) return '';
    if (groupId.isEmpty) return category!.name;
    return "${groupLabels[groupIndex]}'s ${category!.name.toLowerCase()}";
  }

  Future<void> load(String initialGroup) async {
    category = await repository.categoryById(categoryId);
    if (category != null && initialGroup.isNotEmpty) {
      final index = category!.groups.indexOf(initialGroup);
      groupIndex = index < 0 ? 0 : index;
    }
    isLoading = false;
    notifyListeners();
  }

  void setGroup(int index) {
    if (groupIndex == index) return;
    groupIndex = index;
    notifyListeners();
  }
}
