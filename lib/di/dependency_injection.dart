import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import '../core/constants/env_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/local_storage.dart';
import '../modules/alerts/controller/alerts_provider.dart';
import '../modules/auth/controller/auth_provider.dart';
import '../modules/categories/controller/categories_provider.dart';
import '../modules/compare/controller/compare_provider.dart';
import '../modules/home/controller/home_provider.dart';
import '../modules/main_shell/controller/main_shell_provider.dart';
import '../modules/offers/controller/offers_provider.dart';
import '../modules/pro/controller/pro_provider.dart';
import '../modules/profile/controller/profile_provider.dart';
import '../repositories/alerts_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/catalog_repository.dart';
import '../repositories/home_repository.dart';
import '../repositories/preferences_repository.dart';
import '../repositories/subscription_repository.dart';
import '../repositories/user_data_repository.dart';
import '../services/account_sync_service.dart';
import '../services/auth_service.dart';
import '../services/clock_service.dart';
import '../services/link_service.dart';
import '../services/notification_service.dart';
import '../services/supabase_service.dart';

/// Builds every service and repository once, and lists the providers
/// the whole app needs. Screen-only controllers are created in routes.
class DependencyInjection {
  static Future<List<SingleChildWidget>> init() async {
    if (!EnvConfig.hasSupabase) {
      throw StateError('Supabase keys are missing. Run with --dart-define-from-file=env.json');
    }
    await Supabase.initialize(url: EnvConfig.supabaseUrl, publishableKey: EnvConfig.supabaseKey);

    final localStorage = await LocalStorage.create();
    final supabase = SupabaseService(Supabase.instance.client);
    final authService = AuthService(supabase.client);
    final accountSync = AccountSyncService(supabase: supabase, storage: localStorage);
    final apiClient = ApiClient(supabase.client, supabaseUrl: EnvConfig.supabaseUrl);
    final homeRepository = HomeRepository(apiClient: apiClient, supabase: supabase);

    return providers(
      supabase: supabase,
      authRepository: AuthRepository(
        authService: authService,
        accountSync: accountSync,
        supabase: supabase,
        storage: localStorage,
      ),
      homeRepository: homeRepository,
      catalogRepository: CatalogRepository(supabase: supabase, homeRepository: homeRepository),
      preferencesRepository: PreferencesRepository(storage: localStorage, supabase: supabase),
      userDataRepository: UserDataRepository(storage: localStorage, supabase: supabase),
      alertsRepository: AlertsRepository(storage: localStorage, supabase: supabase),
      subscriptionRepository: SubscriptionRepository(storage: localStorage, supabase: supabase),
    );
  }

  /// Everything the widget tree reads. Tests pass in their own repositories.
  static List<SingleChildWidget> providers({
    required SupabaseService supabase,
    required AuthRepository authRepository,
    required HomeRepository homeRepository,
    required CatalogRepository catalogRepository,
    required PreferencesRepository preferencesRepository,
    required UserDataRepository userDataRepository,
    required AlertsRepository alertsRepository,
    required SubscriptionRepository subscriptionRepository,
  }) {
    return [
      // Services
      Provider.value(value: supabase),
      Provider.value(value: NotificationService()),
      Provider.value(value: LinkService()),
      ChangeNotifierProvider(create: (context) => ClockService()),

      // Repositories
      Provider.value(value: authRepository),
      Provider.value(value: homeRepository),
      Provider.value(value: catalogRepository),
      Provider.value(value: preferencesRepository),
      Provider.value(value: userDataRepository),
      Provider.value(value: alertsRepository),
      Provider.value(value: subscriptionRepository),

      // App-wide controllers
      ...ProfileProvider.global(),
      AuthProvider.global(),
      ProProvider.global(),
      MainShellProvider.global(),
      HomeProvider.global(),
      CategoriesProvider.global(),
      OffersProvider.global(),
      CompareProvider.global(),
      AlertsProvider.global(),
    ];
  }
}
