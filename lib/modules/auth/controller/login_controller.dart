import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../services/link_service.dart';
import '../model/login_request_model.dart';
import 'auth_controller.dart';

/// State of the "Welcome to Offpick" screen.
class LoginController extends ChangeNotifier {
  final AuthController authController;
  final LinkService linkService;

  bool isLoading = false;
  String? errorMessage;

  LoginController({required this.authController, required this.linkService});

  Future<bool> continueWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await authController.socialLogin(LoginMethod.google);
      return true;
    } catch (error) {
      errorMessage = AppException.from(error).message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openTerms() => linkService.openInApp(AppConstants.termsUrl);

  Future<void> openPrivacy() => linkService.openInApp(AppConstants.privacyUrl);
}
