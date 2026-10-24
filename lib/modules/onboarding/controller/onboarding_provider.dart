import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../view/welcome_screen.dart';
import 'onboarding_controller.dart';

class OnboardingProvider {
  static Widget screen() {
    return ChangeNotifierProvider(
      create: (context) => OnboardingController(context.read()),
      child: const WelcomeScreen(),
    );
  }
}
