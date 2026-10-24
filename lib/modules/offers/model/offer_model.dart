/// One live deal on one store.
class OfferModel {
  final String id;
  final String brand;
  final String title;
  final String storeId;
  final String storeName;
  final int price;
  final int mrp;
  final DateTime startedAt;
  final DateTime endsAt;
  final String categoryId;
  final String subcategoryId;
  final String groupId;
  final String iconKey;
  final String tint;
  final bool isNew;

  const OfferModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.storeId,
    required this.storeName,
    required this.price,
    required this.mrp,
    required this.startedAt,
    required this.endsAt,
    required this.categoryId,
    required this.subcategoryId,
    required this.groupId,
    required this.iconKey,
    required this.tint,
    required this.isNew,
  });

  /// Rounded down so 47.5% shows as 47%, like the stores do.
  int get discountPercent => ((mrp - price) * 100 / mrp).floor();

  int get savings => mrp - price;

  bool isLiveAt(DateTime now) => endsAt.isAfter(now);

  bool matchesQuery(String query) {
    final text = '$brand $title $storeName $subcategoryId'.toLowerCase();
    return query.toLowerCase().split(' ').where((word) => word.isNotEmpty).every(text.contains);
  }

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      title: json['title'] as String,
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      price: json['price'] as int,
      mrp: json['mrp'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      categoryId: json['categoryId'] as String,
      subcategoryId: json['subcategoryId'] as String,
      groupId: json['groupId'] as String? ?? '',
      iconKey: json['icon'] as String,
      tint: json['tint'] as String,
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'title': title,
        'storeId': storeId,
        'storeName': storeName,
        'price': price,
        'mrp': mrp,
        'startedAt': startedAt.toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'groupId': groupId,
        'icon': iconKey,
        'tint': tint,
        'isNew': isNew,
      };
}
