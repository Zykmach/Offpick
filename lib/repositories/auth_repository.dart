import '../core/network/api_endpoints.dart';
import '../modules/auth/model/login_request_model.dart';
import '../modules/auth/model/login_response_model.dart';
import '../modules/auth/model/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final ApiService apiService;
  final AuthService authService;

  AuthRepository({required this.apiService, required this.authService});

  UserModel? get currentUser => authService.savedUser;

  Future<bool> restoreSession() => authService.restoreSession();

  Future<LoginResponseModel> socialLogin(LoginRequestModel request) async {
    final json = await apiService.post(ApiEndpoints.socialLogin, body: request.toJson());
    final response = LoginResponseModel.fromJson(json);
    await authService.saveSession(response.token, response.user);
    return response;
  }

  Future<UserModel> updateName(UserModel user, String name) async {
    final updated = user.copyWith(name: name.trim());
    await authService.saveUser(updated);
    return updated;
  }

  Future<void> logout() => authService.clearSession();
}
