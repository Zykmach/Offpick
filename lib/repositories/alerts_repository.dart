import '../core/constants/app_constants.dart';
import '../core/constants/db_tables.dart';
import '../core/storage/local_storage.dart';
import '../modules/alerts/model/alert_model.dart';
import '../modules/alerts/model/notification_model.dart';
import '../services/supabase_service.dart';

class AlertsRepository {
  final LocalStorage storage;
  final SupabaseService supabase;

  AlertsRepository({required this.storage, required this.supabase});

  /// Alerts were copied from Supabase at login, see AccountSyncService.
  Future<List<AlertModel>> fetchAlerts() async {
    final saved = storage.getJsonList(AppConstants.keyAlerts) ?? [];
    return saved.map(AlertModel.fromJson).toList();
  }

  Future<void> saveAlerts(List<AlertModel> alerts) async {
    final json = alerts.map((alert) => alert.toJson()).toList();
    await storage.setJsonList(AppConstants.keyAlerts, json);
    await supabase.push((client) => client.rpc(DbTables.setAlerts, params: {'items': json}));
  }

  /// Notifications stay on this phone until push alerts are built.
  Future<List<NotificationModel>> fetchNotifications() async {
    final saved = storage.getJsonList(AppConstants.keyNotifications) ?? [];
    return saved.map(NotificationModel.fromJson).toList();
  }

  Future<void> saveNotifications(List<NotificationModel> notifications) {
    return storage.setJsonList(
      AppConstants.keyNotifications,
      notifications.map((item) => item.toJson()).toList(),
    );
  }
}
