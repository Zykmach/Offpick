import '../core/network/api_endpoints.dart';
import '../modules/compare/model/comparison_model.dart';
import '../modules/offers/model/offer_model.dart';
import '../modules/search/model/trending_model.dart';
import '../services/api_service.dart';

/// Offers, price comparisons and trending searches.
class HomeRepository {
  final ApiService apiService;
  List<OfferModel>? cachedOffers;

  HomeRepository(this.apiService);

  Future<List<OfferModel>> fetchOffers({bool refresh = false}) async {
    if (cachedOffers != null && !refresh) return cachedOffers!;
    final json = await apiService.getList(ApiEndpoints.offers);
    cachedOffers = json.map(OfferModel.fromJson).toList();
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

  Future<ComparisonModel> fetchComparison(String offerId) async {
    final json = await apiService.getMap(ApiEndpoints.offerPrices(offerId));
    return ComparisonModel.fromJson(json);
  }

  Future<List<TrendingModel>> fetchTrending() async {
    final json = await apiService.getList(ApiEndpoints.trending);
    return json.map(TrendingModel.fromJson).toList();
  }
}
