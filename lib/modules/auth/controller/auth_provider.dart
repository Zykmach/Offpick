import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view/auth_screen.dart';
import 'auth_controller.dart';
import 'login_controller.dart';

class AuthProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(
      create: (context) => AuthController(
        authRepository: context.read(),
        preferences: context.read(),
      ),
    );
  }

  static Widget authScreen() {
    return ChangeNotifierProvider(
      create: (context) => LoginController(authController: context.read(), linkService: context.read()),
      child: const AuthScreen(),
    );
  }
}
