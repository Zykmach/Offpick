import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/network/api_client.dart';
import '../core/storage/local_storage.dart';
import '../core/storage/secure_storage.dart';
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
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/clock_service.dart';
import '../services/link_service.dart';
import '../services/mock/mock_server.dart';
import '../services/notification_service.dart';

/// Builds every service and repository once, and lists the providers
/// the whole app needs. Screen-only controllers are created in routes.
class DependencyInjection {
  static Future<List<SingleChildWidget>> init() async {
    final localStorage = await LocalStorage.create();
    final secureStorage = SecureStorage();
    final apiService = ApiService(ApiClient(mockServer: MockServer()));
    final authService = AuthService(
      localStorage: localStorage,
      secureStorage: secureStorage,
      apiService: apiService,
    );

    return [
      // Services
      Provider.value(value: apiService),
      Provider.value(value: NotificationService()),
      Provider.value(value: LinkService()),
      ChangeNotifierProvider(create: (context) => ClockService()),

      // Repositories
      Provider.value(value: AuthRepository(apiService: apiService, authService: authService)),
      Provider.value(value: HomeRepository(apiService)),
      Provider.value(value: CatalogRepository(apiService)),
      Provider.value(value: PreferencesRepository(localStorage)),
      Provider.value(value: UserDataRepository(storage: localStorage, apiService: apiService)),
      Provider.value(value: AlertsRepository(storage: localStorage, apiService: apiService)),
      Provider.value(value: SubscriptionRepository(storage: localStorage, apiService: apiService)),

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
