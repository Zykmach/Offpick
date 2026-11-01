class AppConstants {
  static const String appName = 'Offpick';
  static const String tagline = 'Pick smart. Pay less.';

  static const String supportEmail = 'support@offpick.app';
  static const String termsUrl = 'https://offpick.app/terms';
  static const String privacyUrl = 'https://offpick.app/privacy';

  static const String yearlyPrice = '99';
  static const String monthlyPrice = '9';

  static const int maxRecentSearches = 6;

  static const Duration splashDuration = Duration(milliseconds: 2200);
  static const Duration redirectDuration = Duration(milliseconds: 2600);
  static const Duration fakeAlertDelay = Duration(seconds: 8);

  // Keys used in local storage.
  static const String keyOnboarded = 'onboarded';
  static const String keyUser = 'user';
  static const String keyInterests = 'interests';
  static const String keyStores = 'stores';
  static const String keyInterestsDone = 'interests_done';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsOn = 'notifications_on';
  static const String keyRecentSearches = 'recent_searches';
  static const String keySavedOffers = 'saved_offers';
  static const String keyTrackedProducts = 'tracked_products';
  static const String keyAlerts = 'alerts';
  static const String keyNotifications = 'notifications';
  static const String keyIsPro = 'is_pro';
  static const String keyProPlan = 'pro_plan';
}
