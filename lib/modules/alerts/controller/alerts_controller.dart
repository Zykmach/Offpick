import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../repositories/alerts_repository.dart';
import '../../../services/notification_service.dart';
import '../model/alert_model.dart';
import '../model/alert_trigger.dart';
import '../model/notification_model.dart';

/// Alerts the user set up and the notifications they produced.
class AlertsController extends ChangeNotifier {
  final AlertsRepository repository;
  final NotificationService notificationService;

  List<AlertModel> alerts = [];
  List<NotificationModel> notifications = [];
  int tabIndex = 0;
  bool isLoading = false;
  String? errorMessage;
  final List<Timer> pendingTimers = [];

  AlertsController({required this.repository, required this.notificationService});

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  int get activeCount => alerts.where((alert) => alert.isActive).length;

  AlertModel? alertFor(String targetId) {
    for (final alert in alerts) {
      if (alert.targetId == targetId) return alert;
    }
    return null;
  }

  /// Notifications split into "TODAY", "YESTERDAY" and "EARLIER".
  Map<String, List<NotificationModel>> get groupedNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final groups = <String, List<NotificationModel>>{};
    final sorted = [...notifications]..sort((first, second) => second.createdAt.compareTo(first.createdAt));

    for (final item in sorted) {
      final day = DateTime(item.createdAt.year, item.createdAt.month, item.createdAt.day);
      final daysAgo = today.difference(day).inDays;
      final label = daysAgo == 0 ? 'TODAY' : (daysAgo == 1 ? 'YESTERDAY' : 'EARLIER');
      groups.putIfAbsent(label, () => []).add(item);
    }
    return groups;
  }

  Future<void> load() async {
    isLoading = alerts.isEmpty && notifications.isEmpty;
    errorMessage = null;
    notifyListeners();
    try {
      alerts = await repository.fetchAlerts();
      notifications = await repository.fetchNotifications();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  Future<void> markAllRead() async {
    notifications = notifications.map((item) => item.copyWith(isRead: true)).toList();
    notifyListeners();
    await repository.saveNotifications(notifications);
  }

  Future<void> markRead(String id) async {
    notifications = notifications.map((item) => item.id == id ? item.copyWith(isRead: true) : item).toList();
    notifyListeners();
    await repository.saveNotifications(notifications);
  }

  Future<void> deleteNotification(String id) async {
    notifications = notifications.where((item) => item.id != id).toList();
    notifyListeners();
    await repository.saveNotifications(notifications);
  }

  Future<void> toggleAlert(String id, bool isActive) async {
    alerts = alerts.map((alert) => alert.id == id ? alert.copyWith(isActive: isActive) : alert).toList();
    notifyListeners();
    await repository.saveAlerts(alerts);
  }

  Future<void> deleteAlert(String id) async {
    alerts = alerts.where((alert) => alert.id != id).toList();
    notifyListeners();
    await repository.saveAlerts(alerts);
  }

  /// Saves the alert. An alert on the same product / category is replaced.
  Future<AlertModel> saveAlert(AlertModel alert, {String? previewBody}) async {
    final existing = alertFor(alert.targetId);
    final saved = existing == null
        ? alert
        : AlertModel.fromJson({...alert.toJson(), 'id': existing.id});

    alerts = [saved, ...alerts.where((item) => item.targetId != alert.targetId)];
    notifyListeners();
    await repository.saveAlerts(alerts);
    if (previewBody != null) scheduleDemoNotification(saved, previewBody);
    return saved;
  }

  /// There is no real push backend yet, so we fake the first match a few
  /// seconds later to show how alerts behave.
  void scheduleDemoNotification(AlertModel alert, String body) {
    final timer = Timer(AppConstants.fakeAlertDelay, () {
      final trigger = alert.triggers.isEmpty ? AlertTrigger.newOffer : alert.triggers.first;
      final notification = NotificationModel(
        id: 'note-${DateTime.now().millisecondsSinceEpoch}',
        type: trigger,
        title: trigger.previewTitle(alert.title),
        body: body,
        createdAt: DateTime.now(),
        isRead: false,
        offerId: alert.isProduct ? alert.targetId : null,
      );
      notifications = [notification, ...notifications];
      notifyListeners();
      repository.saveNotifications(notifications);
      notificationService.showBanner(title: notification.title, body: notification.body);
    });
    pendingTimers.add(timer);
  }

  @override
  void dispose() {
    for (final timer in pendingTimers) {
      timer.cancel();
    }
    super.dispose();
  }
}
