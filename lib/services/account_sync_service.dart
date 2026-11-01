import '../core/constants/app_constants.dart';
import '../core/constants/db_tables.dart';
import '../core/storage/local_storage.dart';
import '../modules/auth/model/login_response_model.dart';
import '../modules/auth/model/user_model.dart';
import 'supabase_service.dart';

/// After login, copies the account's data from Supabase into local storage.
/// The repositories read from local storage, so screens open instantly and
/// a new phone gets the same saved offers, alerts and interests.
class AccountSyncService {
  final SupabaseService supabase;
  final LocalStorage storage;

  AccountSyncService({required this.supabase, required this.storage});

  Future<LoginResponseModel> pull() async {
    final client = supabase.client;
    final userId = supabase.userId!;

    final results = await Future.wait<Object?>([
      client.from(DbTables.profiles).select().eq('id', userId).single(),
      client.from(DbTables.savedOffers).select('offer_id').order('created_at'),
      client.from(DbTables.trackedProducts).select('offer_id').order('position'),
      client.from(DbTables.alerts).select().order('position'),
      client.from(DbTables.subscriptions).select('status, expires_at').maybeSingle(),
    ]);

    final profile = results[0] as Map<String, dynamic>;
    final saved = results[1] as List<Map<String, dynamic>>;
    final tracked = results[2] as List<Map<String, dynamic>>;
    final alerts = results[3] as List<Map<String, dynamic>>;
    final subscription = results[4] as Map<String, dynamic>?;

    final email = profile['email'] as String;
    final name = profile['name'] as String;
    final user = UserModel(
      id: userId,
      // Email sign-ups have no name yet, so start with the part before the @.
      name: name.isEmpty ? email.split('@').first : name,
      email: email,
      phone: profile['phone'] as String,
    );
    final interestsDone = profile['interests_done'] as bool;

    await storage.setJson(AppConstants.keyUser, user.toJson());
    await storage.setStringList(AppConstants.keyInterests, (profile['interest_ids'] as List).cast<String>());
    await storage.setStringList(AppConstants.keyStores, (profile['store_ids'] as List).cast<String>());
    await storage.setBool(AppConstants.keyInterestsDone, interestsDone);
    await storage.setStringList(AppConstants.keySavedOffers, saved.map(offerIdOf).toList());
    await storage.setStringList(AppConstants.keyTrackedProducts, tracked.map(offerIdOf).toList());
    await storage.setJsonList(AppConstants.keyAlerts, alerts.map(alertJson).toList());
    await storage.setBool(AppConstants.keyIsPro, isActive(subscription));

    return LoginResponseModel(user: user, isNewUser: !interestsDone);
  }

  String offerIdOf(Map<String, dynamic> row) => row['offer_id'] as String;

  /// Database row -> the JSON shape AlertModel.fromJson reads.
  Map<String, dynamic> alertJson(Map<String, dynamic> row) => {
        'id': row['id'],
        'target': row['target'],
        'targetId': row['target_id'],
        'title': row['title'],
        'detail': row['detail'],
        'icon': row['icon'],
        'tint': row['tint'],
        'triggers': row['triggers'],
        'isActive': row['is_active'],
      };

  static bool isActive(Map<String, dynamic>? subscription) {
    if (subscription == null || subscription['status'] != 'active') return false;
    return DateTime.parse(subscription['expires_at'] as String).isAfter(DateTime.now());
  }
}
