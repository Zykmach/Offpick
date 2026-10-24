class ApiEndpoints {
  static const String socialLogin = '/auth/social';

  static const String offers = '/offers';
  static const String categories = '/categories';
  static const String stores = '/stores';
  static const String interests = '/interests';
  static const String trending = '/search/trending';
  static const String notifications = '/notifications';
  static const String alerts = '/alerts';
  static const String trackedProducts = '/compare/tracked';

  static const String purchasePro = '/subscriptions/purchase';
  static const String restorePro = '/subscriptions/restore';

  static String offerPrices(String offerId) => '/offers/$offerId/prices';
}
