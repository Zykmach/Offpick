import 'package:flutter/foundation.dart';

/// Which bottom tab is open.
class MainShellController extends ChangeNotifier {
  static const int homeTab = 0;
  static const int categoriesTab = 1;
  static const int compareTab = 2;
  static const int alertsTab = 3;
  static const int profileTab = 4;

  int currentTab = homeTab;

  void setTab(int index) {
    if (currentTab == index) return;
    currentTab = index;
    notifyListeners();
  }

  void reset() {
    currentTab = homeTab;
    notifyListeners();
  }
}
