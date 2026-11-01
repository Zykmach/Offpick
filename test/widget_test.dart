import 'package:flutter_test/flutter_test.dart';
import 'package:offpick/core/utils/formatters.dart';
import 'package:offpick/core/utils/validators.dart';
import 'package:offpick/modules/compare/model/comparison_model.dart';
import 'package:offpick/modules/offers/model/offer_filter_model.dart';
import 'package:offpick/modules/offers/model/offer_model.dart';

/// Rows shaped like the offer_feed view in Supabase.
Map<String, dynamic> offerJson(String id, String brand, String title, String storeId, int price, int mrp) {
  return {
    'id': id,
    'brand': brand,
    'title': title,
    'storeId': storeId,
    'storeName': storeId,
    'price': price,
    'mrp': mrp,
    'startedAt': '2026-10-25T10:00:00+00:00',
    'endsAt': '2026-10-28T10:00:00+00:00',
    'categoryId': 'fashion',
    'subcategoryId': 'men-shirts',
    'groupId': 'men',
    'icon': 'shirt',
    'tint': 'green',
    'isNew': false,
  };
}

Map<String, dynamic> priceJson(String storeId, String storeName, int price) {
  return {
    'storeId': storeId,
    'storeName': storeName,
    'monogram': storeName[0],
    'price': price,
    'mrp': 1999,
    'endsAt': '2026-10-28T10:00:00+00:00',
  };
}

void main() {
  final offers = [
    offerJson('levis-oxford', "Levi's", 'Slim Fit Oxford Shirt', 'myntra', 1199, 2499),
    offerJson('nike-casual', 'Nike', 'Nike Casual Shirt', 'flipkart', 1199, 1999),
    offerJson('uspolo-linen', 'U.S. Polo', 'Linen Blend Shirt', 'ajio', 879, 2199),
    offerJson('hm-denim', 'H&M', 'Regular Fit Denim Shirt', 'amazon', 1099, 1999),
    offerJson('roadster-tee', 'Roadster', 'Graphic Print T-Shirt', 'myntra', 349, 999),
  ].map(OfferModel.fromJson).toList();

  group('Formatters', () {
    test('formats prices in the Indian style', () {
      expect(Formatters.price(1199), '₹1,199');
      expect(Formatters.price(124999), '₹1,24,999');
    });

    test('formats countdowns', () {
      expect(Formatters.clock(const Duration(hours: 2, minutes: 14, seconds: 36)), '02:14:36');
      expect(Formatters.timeLeft(const Duration(hours: 2, minutes: 14)), '2h 14m left');
      expect(Formatters.endsIn(const Duration(hours: 26)), 'Ends in 1 day');
      expect(Formatters.endsIn(const Duration(hours: 5, minutes: 20)), 'Ends in 5h 20m');
    });

    test('makes initials', () {
      expect(Formatters.initials('Rahul Mehta'), 'RM');
      expect(Formatters.initials('rahul'), 'R');
    });
  });

  group('Validators', () {
    test('checks names', () {
      expect(Validators.name('Rahul'), isNull);
      expect(Validators.name(' '), isNotNull);
    });
  });

  group('Offers', () {
    test('discount is rounded down like the stores do', () {
      final levis = offers.firstWhere((offer) => offer.id == 'levis-oxford');
      expect(levis.discountPercent, 52);
    });

    test('search matches brand and title words', () {
      final matches = offers.where((offer) => offer.matchesQuery('shirt')).map((offer) => offer.id);
      expect(matches, containsAll(['levis-oxford', 'nike-casual', 'uspolo-linen', 'hm-denim']));
    });

    test('coupon deals without a price use the deal text', () {
      final deal = OfferModel.fromJson({
        ...offerJson('cl-24', 'Myntra', 'Flat 50% off on shirts', 'myntra', 0, 0),
        'price': null,
        'mrp': null,
        'discount': 50,
        'couponCode': 'MYN50',
      });
      expect(deal.hasPrice, isFalse);
      expect(deal.discountPercent, 50);
      expect(deal.savings, 0);
      expect(deal.dealLabel, 'Code MYN50');
    });

    test('filter keeps big discounts and sorts by discount', () {
      const filter = OfferFilterModel(sort: OfferSort.biggestDiscount, minDiscount: 50);
      final result = filter.apply(offers);
      expect(result.every((offer) => offer.discountPercent >= 50), isTrue);
      expect(result.first.discountPercent >= result.last.discountPercent, isTrue);
    });
  });

  group('Compare', () {
    test('Nike shirt is cheapest on Myntra and saves 200 vs Flipkart', () {
      final comparison = ComparisonModel.fromJson({
        'offerId': 'nike-casual',
        'productName': 'Nike Casual Shirt',
        'variant': 'Size M · Navy',
        'icon': 'shirt',
        'tint': 'blue',
        'viewingStoreId': 'flipkart',
        'updatedAt': '2026-10-25T10:00:00+00:00',
        'prices': [
          priceJson('flipkart', 'Flipkart', 1199),
          priceJson('amazon', 'Amazon', 1299),
          priceJson('myntra', 'Myntra', 999),
          priceJson('ajio', 'AJIO', 1049),
        ],
      });
      expect(comparison.best.storeName, 'Myntra');
      expect(comparison.best.price, 999);
      expect(comparison.savingVsViewing, 200);
      expect(comparison.highestPrice, 1299);
    });
  });
}
