/// One live deal on one store. Cuelinks deals are coupons or store-wide
/// offers, so [price] and [mrp] are only set for single-product offers.
class OfferModel {
  final String id;
  final String brand;
  final String title;
  final String storeId;
  final String storeName;
  final int? price;
  final int? mrp;

  /// "Up to 60% off" from the deal text, used when there is no price.
  final int discount;
  final String couponCode;
  final String description;
  final String terms;

  /// Plain store link. It is turned into an affiliate link when opened.
  final String url;
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
    this.price,
    this.mrp,
    this.discount = 0,
    this.couponCode = '',
    this.description = '',
    this.terms = '',
    this.url = '',
    required this.startedAt,
    required this.endsAt,
    required this.categoryId,
    required this.subcategoryId,
    required this.groupId,
    required this.iconKey,
    required this.tint,
    required this.isNew,
  });

  bool get hasPrice => price != null && mrp != null && mrp! > 0;

  /// Rounded down so 47.5% shows as 47%, like the stores do.
  int get discountPercent => hasPrice ? ((mrp! - price!) * 100 / mrp!).floor() : discount;

  int get savings => hasPrice ? mrp! - price! : 0;

  bool get hasCoupon => couponCode.isNotEmpty;

  /// Short text shown where a price would be: "Code SAVE10", "60% off" or "Store deal".
  String get dealLabel {
    if (hasCoupon) return 'Code $couponCode';
    if (discount > 0) return '$discount% off';
    return 'Store deal';
  }

  bool isLiveAt(DateTime now) => endsAt.isAfter(now);

  bool matchesQuery(String query) {
    final text = '$brand $title $description $storeName $subcategoryId'.toLowerCase();
    return query.toLowerCase().split(' ').where((word) => word.isNotEmpty).every(text.contains);
  }

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      title: json['title'] as String,
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      price: json['price'] as int?,
      mrp: json['mrp'] as int?,
      discount: json['discount'] as int? ?? 0,
      couponCode: json['couponCode'] as String? ?? '',
      description: json['description'] as String? ?? '',
      terms: json['terms'] as String? ?? '',
      url: json['url'] as String? ?? '',
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
        'discount': discount,
        'couponCode': couponCode,
        'description': description,
        'terms': terms,
        'url': url,
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
