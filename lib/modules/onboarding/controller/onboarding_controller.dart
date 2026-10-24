import 'package:flutter/material.dart';

import '../../../repositories/preferences_repository.dart';
import '../model/onboarding_page_model.dart';

class OnboardingController extends ChangeNotifier {
  final PreferencesRepository preferences;
  final PageController pageController = PageController();

  int currentPage = 0;

  OnboardingController(this.preferences);

  List<OnboardingPageModel> get pages => OnboardingPageModel.pages;

  OnboardingPageModel get page => pages[currentPage];

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> finish() => preferences.setOnboarded();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
