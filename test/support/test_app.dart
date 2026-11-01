import 'package:flutter/material.dart';
import 'package:offpick/core/constants/app_constants.dart';
import 'package:offpick/core/network/api_client.dart';
import 'package:offpick/core/storage/local_storage.dart';
import 'package:offpick/core/theme/app_theme.dart';
import 'package:offpick/core/utils/responsive.dart';
import 'package:offpick/di/dependency_injection.dart';
import 'package:offpick/modules/categories/model/category_model.dart';
import 'package:offpick/modules/interests/model/interest_model.dart';
import 'package:offpick/modules/offers/model/offer_model.dart';
import 'package:offpick/modules/offers/model/store_model.dart';
import 'package:offpick/modules/search/model/trending_model.dart';
import 'package:offpick/repositories/alerts_repository.dart';
import 'package:offpick/repositories/auth_repository.dart';
import 'package:offpick/repositories/catalog_repository.dart';
import 'package:offpick/repositories/home_repository.dart';
import 'package:offpick/repositories/preferences_repository.dart';
import 'package:offpick/repositories/subscription_repository.dart';
import 'package:offpick/repositories/user_data_repository.dart';
import 'package:offpick/routes/route_generator.dart';
import 'package:offpick/services/account_sync_service.dart';
import 'package:offpick/services/auth_service.dart';
import 'package:offpick/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import 'fixtures.dart';

/// Offers come from the fixtures instead of the "offers" function.
class TestHomeRepository extends HomeRepository {
  TestHomeRepository({required super.apiClient, required super.supabase}) {
    cachedOffers = Fixtures.offers.map(OfferModel.fromJson).toList();
  }

  @override
  Future<List<OfferModel>> fetchOffers({bool refresh = false}) async => cachedOffers!;

  @override
  Future<List<TrendingModel>> fetchTrending() async => Fixtures.trending.map(TrendingModel.fromJson).toList();

  @override
  Future<String> storeLink({required String url, required String offerId}) async => url;
}

/// Builds the real app around sample data, starting on [route].
Future<Widget> buildTestApp(String route, {Object? arguments}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorage.create();
  await storage.setBool(AppConstants.keyOnboarded, true);
  await storage.setBool(AppConstants.keyInterestsDone, true);
  await storage.setStringList(AppConstants.keyInterests, ['men', 'beauty']);
  await storage.setStringList(AppConstants.keySavedOffers, ['cl-1', 'cl-2', 'cl-3']);
  await storage.setStringList(AppConstants.keyTrackedProducts, ['cl-2', 'cl-4']);
  await storage.setJsonList(AppConstants.keyAlerts, [Fixtures.alert]);
  await storage.setJson(AppConstants.keyUser, {
    'id': 'user-1',
    'name': 'Rahul Venkataraman Subramanian',
    'email': 'rahul.venkataraman.subramanian@gmail.com',
  });

  final client = SupabaseClient('https://test.supabase.co', 'test-key');
  final supabase = SupabaseService(client);
  final homeRepository = TestHomeRepository(
    apiClient: ApiClient(client, supabaseUrl: 'https://test.supabase.co'),
    supabase: supabase,
  );
  final catalogRepository = CatalogRepository(supabase: supabase, homeRepository: homeRepository)
    ..cachedCategories = Fixtures.categories
        .map((row) => CategoryModel.fromJson({
              ...row,
              'liveOffers': 12,
              'subcategories': (row['subcategories'] as List)
                  .map((item) => {...(item as Map<String, dynamic>), 'offerCount': 3})
                  .toList(),
            }))
        .toList()
    ..cachedStores = Fixtures.stores.map(StoreModel.fromJson).toList()
    ..cachedInterests = Fixtures.interests.map(InterestModel.fromJson).toList();

  final providers = DependencyInjection.providers(
    supabase: supabase,
    authRepository: AuthRepository(
      authService: AuthService(client),
      accountSync: AccountSyncService(supabase: supabase, storage: storage),
      supabase: supabase,
      storage: storage,
    ),
    homeRepository: homeRepository,
    catalogRepository: catalogRepository,
    preferencesRepository: PreferencesRepository(storage: storage, supabase: supabase),
    userDataRepository: UserDataRepository(storage: storage, supabase: supabase),
    alertsRepository: AlertsRepository(storage: storage, supabase: supabase),
    subscriptionRepository: SubscriptionRepository(storage: storage, supabase: supabase),
  );

  return MultiProvider(
    providers: providers,
    child: MaterialApp(
      theme: AppTheme.light,
      builder: Responsive.wrap,
      onGenerateRoute: RouteGenerator.generate,
      onGenerateInitialRoutes: (name) => [
        RouteGenerator.generate(RouteSettings(name: route, arguments: arguments)),
      ],
    ),
  );
}
