/// A product type inside a category, e.g. Men's Shirts or Skincare.
class SubcategoryModel {
  final String id;
  final String name;
  final String categoryId;
  final String groupId;
  final String iconKey;
  final String tint;
  final int offerCount;

  const SubcategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.groupId,
    required this.iconKey,
    required this.tint,
    required this.offerCount,
  });

  /// "Men's Shirts", "Skincare"
  String get fullName {
    if (groupId == 'men') return "Men's $name";
    if (groupId == 'women') return "Women's $name";
    return name;
  }

  /// "Men › Shirts", "Beauty › Skincare"
  String pathName(String categoryName) {
    if (groupId == 'men') return 'Men › $name';
    if (groupId == 'women') return 'Women › $name';
    return '$categoryName › $name';
  }

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      groupId: json['groupId'] as String? ?? '',
      iconKey: json['icon'] as String,
      tint: json['tint'] as String,
      offerCount: json['offerCount'] as int,
    );
  }
}
