import '../core/constants/app_constants.dart';
import '../core/constants/db_tables.dart';
import '../core/storage/local_storage.dart';
import '../services/supabase_service.dart';

/// Saved (hearted) offers and products tracked in Compare.
/// Read from the local copy, every change is also sent to Supabase.
class UserDataRepository {
  final LocalStorage storage;
  final SupabaseService supabase;

  UserDataRepository({required this.storage, required this.supabase});

  List<String> get savedOfferIds => storage.getStringList(AppConstants.keySavedOffers);

  Future<void> saveOfferIds(List<String> ids) async {
    await storage.setStringList(AppConstants.keySavedOffers, ids);
    await supabase.push((client) => client.rpc(DbTables.setSavedOffers, params: {'offer_ids': ids}));
  }

  Future<List<String>> fetchTrackedIds() async => storage.getStringList(AppConstants.keyTrackedProducts);

  Future<void> saveTrackedIds(List<String> ids) async {
    await storage.setStringList(AppConstants.keyTrackedProducts, ids);
    await supabase.push((client) => client.rpc(DbTables.setTrackedProducts, params: {'offer_ids': ids}));
  }
}
