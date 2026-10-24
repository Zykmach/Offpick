import '../core/constants/app_constants.dart';
import '../core/storage/local_storage.dart';
import '../core/storage/secure_storage.dart';
import '../modules/auth/model/user_model.dart';
import 'api_service.dart';

/// Keeps the logged in session: token in secure storage, profile in prefs.
class AuthService {
  final LocalStorage localStorage;
  final SecureStorage secureStorage;
  final ApiService apiService;

  AuthService({required this.localStorage, required this.secureStorage, required this.apiService});

  UserModel? get savedUser {
    final json = localStorage.getJson(AppConstants.keyUser);
    return json == null ? null : UserModel.fromJson(json);
  }

  Future<bool> restoreSession() async {
    final token = await secureStorage.readToken();
    if (token == null || savedUser == null) return false;
    apiService.setToken(token);
    return true;
  }

  Future<void> saveSession(String token, UserModel user) async {
    await secureStorage.saveToken(token);
    await localStorage.setJson(AppConstants.keyUser, user.toJson());
    apiService.setToken(token);
  }

  Future<void> saveUser(UserModel user) => localStorage.setJson(AppConstants.keyUser, user.toJson());

  Future<void> clearSession() async {
    await secureStorage.clearToken();
    await localStorage.remove(AppConstants.keyUser);
    apiService.setToken(null);
  }
}
