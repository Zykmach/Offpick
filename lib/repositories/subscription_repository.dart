import '../core/constants/app_constants.dart';
import '../core/network/api_endpoints.dart';
import '../core/storage/local_storage.dart';
import '../modules/pro/model/plan_model.dart';
import '../services/api_service.dart';

/// Offpick Pro purchase state. A real store (Play / App Store) billing
/// SDK should replace the purchase call here.
class SubscriptionRepository {
  final LocalStorage storage;
  final ApiService apiService;

  SubscriptionRepository({required this.storage, required this.apiService});

  bool get isPro => storage.getBool(AppConstants.keyIsPro);

  Future<bool> purchase(PlanModel plan) async {
    final json = await apiService.post(ApiEndpoints.purchasePro, body: {'plan': plan.name});
    final isPro = json['isPro'] as bool? ?? false;
    await storage.setBool(AppConstants.keyIsPro, isPro);
    await storage.setString(AppConstants.keyProPlan, plan.name);
    return isPro;
  }

  Future<bool> restore() async {
    final hadPurchase = storage.has(AppConstants.keyProPlan);
    final json = await apiService.post(ApiEndpoints.restorePro, body: {'hadPurchase': hadPurchase});
    final isPro = json['isPro'] as bool? ?? false;
    await storage.setBool(AppConstants.keyIsPro, isPro);
    return isPro;
  }
}
