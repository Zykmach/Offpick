import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/storage/local_storage.dart';

/// Settings and choices that only live on this device.
class PreferencesRepository {
  final LocalStorage storage;

  PreferencesRepository(this.storage);

  bool get isOnboarded => storage.getBool(AppConstants.keyOnboarded);

  Future<void> setOnboarded() => storage.setBool(AppConstants.keyOnboarded, true);

  bool get hasPickedInterests => storage.getBool(AppConstants.keyInterestsDone);

  Future<void> setPickedInterests(bool value) => storage.setBool(AppConstants.keyInterestsDone, value);

  List<String> get interestIds => storage.getStringList(AppConstants.keyInterests);

  Future<void> saveInterestIds(List<String> ids) => storage.setStringList(AppConstants.keyInterests, ids);

  List<String> get storeIds => storage.getStringList(AppConstants.keyStores);

  Future<void> saveStoreIds(List<String> ids) => storage.setStringList(AppConstants.keyStores, ids);

  ThemeMode get themeMode {
    final name = storage.getString(AppConstants.keyThemeMode);
    return ThemeMode.values.firstWhere((mode) => mode.name == name, orElse: () => ThemeMode.system);
  }

  Future<void> saveThemeMode(ThemeMode mode) => storage.setString(AppConstants.keyThemeMode, mode.name);

  bool get notificationsOn => storage.getBool(AppConstants.keyNotificationsOn, fallback: true);

  Future<void> saveNotificationsOn(bool value) => storage.setBool(AppConstants.keyNotificationsOn, value);

  List<String> get recentSearches {
    if (!storage.has(AppConstants.keyRecentSearches)) {
      return ['shirt', 'running shoes', 'earbuds'];
    }
    return storage.getStringList(AppConstants.keyRecentSearches);
  }

  Future<void> saveRecentSearches(List<String> items) {
    return storage.setStringList(AppConstants.keyRecentSearches, items);
  }

  /// Clears everything tied to the account, keeps theme and onboarding.
  Future<void> clearAccountData() async {
    await storage.remove(AppConstants.keyInterests);
    await storage.remove(AppConstants.keyStores);
    await storage.remove(AppConstants.keyInterestsDone);
    await storage.remove(AppConstants.keyRecentSearches);
    await storage.remove(AppConstants.keySavedOffers);
    await storage.remove(AppConstants.keyTrackedProducts);
    await storage.remove(AppConstants.keyAlerts);
    await storage.remove(AppConstants.keyNotifications);
    await storage.remove(AppConstants.keyIsPro);
    await storage.remove(AppConstants.keyProPlan);
  }
}
