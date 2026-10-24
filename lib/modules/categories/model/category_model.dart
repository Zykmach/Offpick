import 'subcategory_model.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconKey;
  final String tint;
  final int liveOffers;

  /// Fashion is split into Men / Women. Other categories have no groups.
  final List<String> groups;
  final List<SubcategoryModel> subcategories;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.tint,
    required this.liveOffers,
    required this.groups,
    required this.subcategories,
  });

  bool get hasGroups => groups.isNotEmpty;

  List<SubcategoryModel> subcategoriesFor(String groupId) {
    if (groupId.isEmpty) return subcategories;
    return subcategories.where((item) => item.groupId == groupId).toList();
  }

  int offersFor(String groupId) {
    return subcategoriesFor(groupId).fold(0, (sum, item) => sum + item.offerCount);
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: json['icon'] as String,
      tint: json['tint'] as String,
      liveOffers: json['liveOffers'] as int,
      groups: (json['groups'] as List? ?? []).cast<String>(),
      subcategories: (json['subcategories'] as List)
          .map((item) => SubcategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
