import 'store_price_model.dart';

/// The same product across stores, cheapest first.
class ComparisonModel {
  final String offerId;
  final String productName;
  final String variant;
  final String iconKey;
  final String tint;
  final String viewingStoreId;
  final DateTime updatedAt;
  final List<StorePriceModel> prices;

  const ComparisonModel({
    required this.offerId,
    required this.productName,
    required this.variant,
    required this.iconKey,
    required this.tint,
    required this.viewingStoreId,
    required this.updatedAt,
    required this.prices,
  });

  StorePriceModel get best => prices.first;

  int get highestPrice => prices.last.price;

  bool get allSamePrice => best.price == highestPrice;

  StorePriceModel get viewing {
    return prices.firstWhere((item) => item.storeId == viewingStoreId, orElse: () => prices.last);
  }

  /// How much cheaper the best store is than the store the user found it on.
  int get savingVsViewing => viewing.price - best.price;

  /// The next cheapest store, used in "₹200 less than Flipkart".
  StorePriceModel get compareAgainst => viewingStoreId == best.storeId && prices.length > 1 ? prices[1] : viewing;

  factory ComparisonModel.fromJson(Map<String, dynamic> json) {
    final prices = (json['prices'] as List)
        .map((item) => StorePriceModel.fromJson(item as Map<String, dynamic>))
        .toList()
      ..sort((first, second) => first.price.compareTo(second.price));

    return ComparisonModel(
      offerId: json['offerId'] as String,
      productName: json['productName'] as String,
      variant: json['variant'] as String,
      iconKey: json['icon'] as String,
      tint: json['tint'] as String,
      viewingStoreId: json['viewingStoreId'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      prices: prices,
    );
  }
}
