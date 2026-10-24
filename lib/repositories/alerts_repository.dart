import '../core/constants/app_constants.dart';
import '../core/network/api_endpoints.dart';
import '../core/storage/local_storage.dart';
import '../modules/alerts/model/alert_model.dart';
import '../modules/alerts/model/notification_model.dart';
import '../services/api_service.dart';

class AlertsRepository {
  final LocalStorage storage;
  final ApiService apiService;

  AlertsRepository({required this.storage, required this.apiService});

  Future<List<AlertModel>> fetchAlerts() async {
    final saved = storage.getJsonList(AppConstants.keyAlerts);
    if (saved != null) return saved.map(AlertModel.fromJson).toList();

    final json = await apiService.getList(ApiEndpoints.alerts);
    final alerts = json.map(AlertModel.fromJson).toList();
    await saveAlerts(alerts);
    return alerts;
  }

  Future<void> saveAlerts(List<AlertModel> alerts) {
    return storage.setJsonList(AppConstants.keyAlerts, alerts.map((alert) => alert.toJson()).toList());
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    final saved = storage.getJsonList(AppConstants.keyNotifications);
    if (saved != null) return saved.map(NotificationModel.fromJson).toList();

    final json = await apiService.getList(ApiEndpoints.notifications);
    final notifications = json.map(NotificationModel.fromJson).toList();
    await saveNotifications(notifications);
    return notifications;
  }

  Future<void> saveNotifications(List<NotificationModel> notifications) {
    return storage.setJsonList(
      AppConstants.keyNotifications,
      notifications.map((item) => item.toJson()).toList(),
    );
  }
}
