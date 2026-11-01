/// Supabase tables, views and functions the app talks to.
/// The *_feed views return camelCase keys that match the models' fromJson.
class DbTables {
  static const String categoryFeed = 'category_feed';
  static const String storeFeed = 'store_feed';
  static const String interestFeed = 'interest_feed';
  static const String trendingFeed = 'trending_feed';

  static const String profiles = 'profiles';
  static const String savedOffers = 'saved_offers';
  static const String trackedProducts = 'tracked_products';
  static const String alerts = 'alerts';
  static const String subscriptions = 'subscriptions';

  static const String setSavedOffers = 'set_saved_offers';
  static const String setTrackedProducts = 'set_tracked_products';
  static const String setAlerts = 'set_alerts';
}
