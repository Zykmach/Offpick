import '../core/constants/app_constants.dart';
import '../core/constants/db_tables.dart';
import '../core/storage/local_storage.dart';
import '../modules/auth/model/login_request_model.dart';
import '../modules/auth/model/login_response_model.dart';
import '../modules/auth/model/user_model.dart';
import '../services/account_sync_service.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  final AuthService authService;
  final AccountSyncService accountSync;
  final SupabaseService supabase;
  final LocalStorage storage;

  AuthRepository({
    required this.authService,
    required this.accountSync,
    required this.supabase,
    required this.storage,
  });

  UserModel? get currentUser {
    final json = storage.getJson(AppConstants.keyUser);
    return json == null ? null : UserModel.fromJson(json);
  }

  /// Supabase restores its own session. We also need the profile we saved.
  Future<bool> restoreSession() async {
    if (!authService.hasSession) return false;
    if (currentUser != null) return true;
    try {
      await accountSync.pull();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<LoginResponseModel> socialLogin(LoginRequestModel request) async {
    await authService.signInWithGoogle();
    return accountSync.pull();
  }

  Future<UserModel> updateName(UserModel user, String name) async {
    final updated = user.copyWith(name: name.trim());
    await storage.setJson(AppConstants.keyUser, updated.toJson());
    await supabase.push((client) => client.from(DbTables.profiles).update({'name': updated.name}).eq('id', user.id));
    return updated;
  }

  Future<void> logout() async {
    await authService.signOut();
    await storage.remove(AppConstants.keyUser);
  }
}
