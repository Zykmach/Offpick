/// The price of one product on one store.
class StorePriceModel {
  final String storeId;
  final String storeName;
  final String monogram;
  final int price;
  final int mrp;
  final DateTime endsAt;

  const StorePriceModel({
    required this.storeId,
    required this.storeName,
    required this.monogram,
    required this.price,
    required this.mrp,
    required this.endsAt,
  });

  int get discountPercent => ((mrp - price) * 100 / mrp).floor();

  factory StorePriceModel.fromJson(Map<String, dynamic> json) {
    return StorePriceModel(
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      monogram: json['monogram'] as String,
      price: json['price'] as int,
      mrp: json['mrp'] as int,
      endsAt: DateTime.parse(json['endsAt'] as String),
    );
  }
}
