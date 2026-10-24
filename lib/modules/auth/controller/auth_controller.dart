import 'package:flutter/foundation.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/preferences_repository.dart';
import '../../../routes/app_routes.dart';
import '../model/login_request_model.dart';
import '../model/user_model.dart';

/// Holds the logged in user for the whole app.
class AuthController extends ChangeNotifier {
  final AuthRepository authRepository;
  final PreferencesRepository preferences;

  UserModel? user;

  AuthController({required this.authRepository, required this.preferences});

  bool get isLoggedIn => user != null;

  Future<bool> restoreSession() async {
    final hasSession = await authRepository.restoreSession();
    user = hasSession ? authRepository.currentUser : null;
    notifyListeners();
    return hasSession;
  }

  Future<void> socialLogin(LoginMethod method) async {
    final response = await authRepository.socialLogin(LoginRequestModel(method: method));
    await afterLogin(response.user, isNewUser: response.isNewUser);
  }

  Future<void> afterLogin(UserModel loggedInUser, {required bool isNewUser}) async {
    user = loggedInUser;
    if (isNewUser) await preferences.setPickedInterests(false);
    notifyListeners();
  }

  /// New users pick their interests first, everyone else goes home.
  String get routeAfterLogin => preferences.hasPickedInterests ? AppRoutes.main : AppRoutes.interests;

  Future<void> updateName(String name) async {
    if (user == null) return;
    user = await authRepository.updateName(user!, name);
    notifyListeners();
  }

  Future<void> logout() async {
    await authRepository.logout();
    await preferences.clearAccountData();
    user = null;
    notifyListeners();
  }
}
