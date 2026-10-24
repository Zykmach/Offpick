import '../../core/errors/app_exception.dart';
import '../../core/network/api_endpoints.dart';
import 'mock_catalog.dart';
import 'mock_offers.dart';
import 'mock_user_data.dart';

/// Pretends to be the Offpick backend. It answers the same paths the
/// real API will have, so swapping it out later only touches ApiClient.
class MockServer {
  final DateTime bootTime = DateTime.now();

  dynamic handle(
    String method,
    String path, {
    required Map<String, String> query,
    required Map<String, dynamic> body,
  }) {
    if (method == 'GET') {
      if (path == ApiEndpoints.offers) return offers();
      if (path == ApiEndpoints.categories) return MockCatalog.categories;
      if (path == ApiEndpoints.stores) return MockCatalog.stores;
      if (path == ApiEndpoints.interests) return MockCatalog.interests;
      if (path == ApiEndpoints.trending) return MockCatalog.trending;
      if (path == ApiEndpoints.alerts) return MockUserData.alerts;
      if (path == ApiEndpoints.trackedProducts) return MockUserData.trackedProducts;
      if (path == ApiEndpoints.notifications) return MockUserData.notifications(DateTime.now());
      if (path.startsWith('/offers/') && path.endsWith('/prices')) {
        return comparisonFor(path.split('/')[2]);
      }
    }

    if (method == 'POST') {
      if (path == ApiEndpoints.socialLogin) return socialLogin(body);
      if (path == ApiEndpoints.purchasePro) return {'isPro': true, 'plan': body['plan']};
      if (path == ApiEndpoints.restorePro) return {'isPro': body['hadPurchase'] == true};
    }

    throw AppException('Not found: $method $path', statusCode: 404);
  }

  DateTime nextSundayNight() {
    var daysAhead = DateTime.sunday - bootTime.weekday;
    if (daysAhead < 3) daysAhead += 7;
    return DateTime(bootTime.year, bootTime.month, bootTime.day + daysAhead, 23, 59);
  }

  List<Map<String, dynamic>> offers() {
    return MockOffers.rows.map((row) {
      final storeId = row[3] as String;
      final endsInSeconds = row[7] as int;
      final endsAt = endsInSeconds < 0 ? nextSundayNight() : bootTime.add(Duration(seconds: endsInSeconds));
      return {
        'id': row[0],
        'brand': row[1],
        'title': row[2],
        'storeId': storeId,
        'storeName': storeName(storeId),
        'price': row[4],
        'mrp': row[5],
        'startedAt': bootTime.subtract(Duration(minutes: row[6] as int)).toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
        'categoryId': row[8],
        'subcategoryId': row[9],
        'groupId': row[10],
        'icon': row[11],
        'tint': row[12],
        'isNew': row[13],
      };
    }).toList();
  }

  Map<String, dynamic> storeById(String storeId) {
    return MockCatalog.stores.firstWhere((store) => store['id'] == storeId);
  }

  String storeName(String storeId) => storeById(storeId)['name'] as String;

  Map<String, dynamic> priceEntry(String storeId, int price, int mrp, int endsInSeconds) {
    final store = storeById(storeId);
    return {
      'storeId': storeId,
      'storeName': store['name'],
      'monogram': store['monogram'],
      'price': price,
      'mrp': mrp,
      'endsAt': bootTime.add(Duration(seconds: endsInSeconds)).toIso8601String(),
    };
  }

  int roundToNine(double value) => (value / 10).round() * 10 - 1;

  Map<String, dynamic> comparisonFor(String offerId) {
    final offer = offers().firstWhere(
      (item) => item['id'] == offerId,
      orElse: () => throw const AppException('Offer not found', statusCode: 404),
    );
    final known = MockOffers.comparisons[offerId];
    final List<Map<String, dynamic>> prices;
    String viewing = offer['storeId'] as String;
    String variant = 'Standard';

    if (known != null) {
      variant = known['variant'] as String;
      viewing = known['viewing'] as String;
      prices = (known['prices'] as List).map((item) {
        final row = item as List;
        return priceEntry(row[0] as String, row[1] as int, row[2] as int, row[3] as int);
      }).toList();
    } else {
      // Build a believable spread from two other stores.
      final price = offer['price'] as int;
      final mrp = offer['mrp'] as int;
      final others = ['myntra', 'ajio', 'flipkart', 'amazon'].where((id) => id != viewing).toList();
      final shift = offerId.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % others.length;
      final first = others[shift];
      final second = others[(shift + 1) % others.length];
      final endsIn = DateTime.parse(offer['endsAt'] as String).difference(bootTime).inSeconds;
      prices = [
        priceEntry(viewing, price, mrp, endsIn),
        priceEntry(first, roundToNine(price * 0.94).clamp(1, mrp), mrp, endsIn + 86400),
        priceEntry(second, roundToNine(price * 1.09).clamp(1, mrp), mrp, endsIn + 172800),
      ];
    }

    return {
      'offerId': offerId,
      'productName': offer['title'],
      'variant': variant,
      'icon': offer['icon'],
      'tint': offer['tint'],
      'viewingStoreId': viewing,
      'updatedAt': DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
      'prices': prices,
    };
  }

  Map<String, dynamic> socialLogin(Map<String, dynamic> body) {
    final provider = body['method'] as String? ?? 'google';
    final email = 'rahul.mehta@gmail.com';
    return {
      'token': 'mock-$provider-token',
      'isNewUser': false,
      'user': {'id': 'user-${email.hashCode.abs()}', 'name': 'Rahul Mehta', 'email': email},
    };
  }
}
