import '../core/constants/db_tables.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_paths.dart';
import '../modules/compare/model/comparison_model.dart';
import '../modules/offers/model/offer_model.dart';
import '../modules/search/model/trending_model.dart';
import '../services/supabase_service.dart';

/// Live offers from Cuelinks (through our "offers" function), store links
/// and trending searches. Offers are only kept in memory.
class HomeRepository {
  final ApiClient apiClient;
  final SupabaseService supabase;
  List<OfferModel>? cachedOffers;

  HomeRepository({required this.apiClient, required this.supabase});

  Future<List<OfferModel>> fetchOffers({bool refresh = false}) async {
    if (cachedOffers != null && !refresh) return cachedOffers!;
    final json = await apiClient.get(ApiPaths.offers) as List;
    cachedOffers = json.cast<Map<String, dynamic>>().map(OfferModel.fromJson).toList()
      ..sort((first, second) => second.startedAt.compareTo(first.startedAt));
    return cachedOffers!;
  }

  Future<OfferModel?> offerById(String id) async {
    final offers = await fetchOffers();
    for (final offer in offers) {
      if (offer.id == id) return offer;
    }
    return null;
  }

  Future<List<OfferModel>> offersByIds(List<String> ids) async {
    final offers = await fetchOffers();
    return ids
        .map((id) => offers.where((offer) => offer.id == id))
        .where((matches) => matches.isNotEmpty)
        .map((matches) => matches.first)
        .toList();
  }

  Future<List<OfferModel>> search(String query) async {
    final offers = await fetchOffers();
    return offers.where((offer) => offer.matchesQuery(query)).toList();
  }

  /// Only offers with a product price can be compared. Cuelinks deals are
  /// coupons without one, so for now this is the offer on its own store.
  Future<ComparisonModel> fetchComparison(String offerId) async {
    final offer = await offerById(offerId);
    if (offer == null) throw const AppException('This offer has ended');
    if (!offer.hasPrice) throw const AppException('Price comparison is only for products with a price');

    return ComparisonModel.fromJson({
      'offerId': offer.id,
      'productName': offer.title,
      'variant': 'Standard',
      'icon': offer.iconKey,
      'tint': offer.tint,
      'viewingStoreId': offer.storeId,
      'updatedAt': DateTime.now().toIso8601String(),
      'prices': [
        {
          'storeId': offer.storeId,
          'storeName': offer.storeName,
          'monogram': offer.storeName[0],
          'price': offer.price,
          'mrp': offer.mrp,
          'endsAt': offer.endsAt.toIso8601String(),
        },
      ],
    });
  }

  /// Same as [fetchComparison] but gives null instead of an error.
  Future<ComparisonModel?> comparisonOrNull(String offerId) async {
    try {
      return await fetchComparison(offerId);
    } catch (error) {
      return null;
    }
  }

  /// Turns a plain store link into our Cuelinks affiliate link.
  Future<String> storeLink({required String url, required String offerId}) async {
    final json = await apiClient.post(ApiPaths.storeLink, {'url': url, 'offerId': offerId});
    return (json as Map<String, dynamic>)['url'] as String;
  }

  Future<List<TrendingModel>> fetchTrending() async {
    final rows = await supabase.readAll(DbTables.trendingFeed, orderBy: 'rank');
    return rows.map(TrendingModel.fromJson).toList();
  }
}
