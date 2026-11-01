import '../core/constants/app_constants.dart';
import '../core/constants/db_tables.dart';
import '../core/storage/local_storage.dart';
import '../modules/pro/model/plan_model.dart';
import '../services/account_sync_service.dart';
import '../services/supabase_service.dart';

/// Offpick Pro state. The subscriptions table is only written by the server
/// after it checks a Play / App Store receipt, so the app cannot fake Pro.
class SubscriptionRepository {
  final LocalStorage storage;
  final SupabaseService supabase;

  SubscriptionRepository({required this.storage, required this.supabase});

  bool get isPro => storage.getBool(AppConstants.keyIsPro);

  /// Placeholder until Play Billing is added: unlocks Pro on this phone only.
  Future<bool> purchase(PlanModel plan) async {
    await storage.setBool(AppConstants.keyIsPro, true);
    await storage.setString(AppConstants.keyProPlan, plan.name);
    return true;
  }

  Future<bool> restore() async {
    final row = await supabase.client.from(DbTables.subscriptions).select('status, expires_at').maybeSingle();
    final isPro = AccountSyncService.isActive(row);
    await storage.setBool(AppConstants.keyIsPro, isPro);
    return isPro;
  }
}
