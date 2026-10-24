import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../repositories/preferences_repository.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';

class SplashController extends ChangeNotifier {
  final AuthController authController;
  final PreferencesRepository preferences;

  double progress = 0;

  SplashController({required this.authController, required this.preferences});

  /// Restores the session while the logo shows, then says where to go next.
  Future<String> start() async {
    setProgress(0.35);
    final results = await Future.wait([
      authController.restoreSession(),
      Future.delayed(AppConstants.splashDuration),
    ]);
    setProgress(1);
    await Future.delayed(const Duration(milliseconds: 350));

    final isLoggedIn = results.first as bool;
    if (!preferences.isOnboarded) return AppRoutes.welcome;
    if (!isLoggedIn) return AppRoutes.auth;
    if (!preferences.hasPickedInterests) return AppRoutes.interests;
    return AppRoutes.main;
  }

  void setProgress(double value) {
    progress = value;
    notifyListeners();
  }
}
