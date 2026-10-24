import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../view/splash_screen.dart';
import 'splash_controller.dart';

class SplashProvider {
  static Widget screen() {
    return ChangeNotifierProvider(
      create: (context) => SplashController(
        authController: context.read(),
        preferences: context.read(),
      ),
      child: const SplashScreen(),
    );
  }
}
