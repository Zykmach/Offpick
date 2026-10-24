import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../auth/controller/auth_controller.dart';

class EditProfileController extends ChangeNotifier {
  final AuthController authController;
  final TextEditingController nameController;

  bool isSaving = false;
  String? nameError;

  EditProfileController(this.authController)
      : nameController = TextEditingController(text: authController.user?.name ?? '');

  void clearError() {
    if (nameError == null) return;
    nameError = null;
    notifyListeners();
  }

  Future<bool> save() async {
    nameError = Validators.name(nameController.text);
    if (nameError != null) {
      notifyListeners();
      return false;
    }
    isSaving = true;
    notifyListeners();
    await authController.updateName(nameController.text);
    isSaving = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
