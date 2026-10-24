import '../core/constants/app_constants.dart';
import '../core/network/api_endpoints.dart';
import '../core/storage/local_storage.dart';
import '../services/api_service.dart';

/// Saved (hearted) offers and products tracked in Compare.
class UserDataRepository {
  final LocalStorage storage;
  final ApiService apiService;

  UserDataRepository({required this.storage, required this.apiService});

  List<String> get savedOfferIds => storage.getStringList(AppConstants.keySavedOffers);

  Future<void> saveOfferIds(List<String> ids) => storage.setStringList(AppConstants.keySavedOffers, ids);

  /// First launch: take the starter list from the server, then keep it locally.
  Future<List<String>> fetchTrackedIds() async {
    if (storage.has(AppConstants.keyTrackedProducts)) {
      return storage.getStringList(AppConstants.keyTrackedProducts);
    }
    final json = await apiService.getList(ApiEndpoints.trackedProducts);
    final ids = json.map((item) => item['offerId'] as String).toList();
    await saveTrackedIds(ids);
    return ids;
  }

  Future<void> saveTrackedIds(List<String> ids) => storage.setStringList(AppConstants.keyTrackedProducts, ids);
}
