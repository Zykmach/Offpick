import 'package:flutter_test/flutter_test.dart';
import 'package:offpick/core/utils/formatters.dart';
import 'package:offpick/core/utils/validators.dart';
import 'package:offpick/modules/compare/model/comparison_model.dart';
import 'package:offpick/modules/offers/model/offer_filter_model.dart';
import 'package:offpick/modules/offers/model/offer_model.dart';
import 'package:offpick/services/mock/mock_server.dart';

void main() {
  final server = MockServer();
  final offers = (server.offers()).map(OfferModel.fromJson).toList();

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

    test('filter keeps big discounts and sorts by discount', () {
      const filter = OfferFilterModel(sort: OfferSort.biggestDiscount, minDiscount: 50);
      final result = filter.apply(offers);
      expect(result.every((offer) => offer.discountPercent >= 50), isTrue);
      expect(result.first.discountPercent >= result.last.discountPercent, isTrue);
    });
  });

  group('Compare', () {
    test('Nike shirt is cheapest on Myntra and saves 200 vs Flipkart', () {
      final comparison = ComparisonModel.fromJson(server.comparisonFor('nike-casual'));
      expect(comparison.best.storeName, 'Myntra');
      expect(comparison.best.price, 999);
      expect(comparison.savingVsViewing, 200);
      expect(comparison.highestPrice, 1299);
    });

    test('every offer can be compared', () {
      for (final offer in offers) {
        final comparison = ComparisonModel.fromJson(server.comparisonFor(offer.id));
        expect(comparison.prices, isNotEmpty);
      }
    });
  });
}
