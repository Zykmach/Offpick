import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../repositories/preferences_repository.dart';
import '../../../services/link_service.dart';
import '../../../services/notification_service.dart';

/// Settings shown on the "Me" tab.
class ProfileController extends ChangeNotifier {
  final PreferencesRepository preferences;
  final NotificationService notificationService;
  final LinkService linkService;

  bool notificationsOn;
  int interestCount = 0;
  int storeCount = 0;

  ProfileController({
    required this.preferences,
    required this.notificationService,
    required this.linkService,
  }) : notificationsOn = preferences.notificationsOn {
    notificationService.isEnabled = notificationsOn;
    refreshCounts();
  }

  void refreshCounts() {
    interestCount = preferences.interestIds.length;
    storeCount = preferences.storeIds.length;
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    notificationsOn = !notificationsOn;
    notificationService.isEnabled = notificationsOn;
    notifyListeners();
    await preferences.saveNotificationsOn(notificationsOn);
  }

  Future<bool> contactSupport() {
    return linkService.email(AppConstants.supportEmail, subject: 'Offpick help');
  }

  Future<bool> openTerms() => linkService.openInApp(AppConstants.termsUrl);

  Future<bool> openPrivacy() => linkService.openInApp(AppConstants.privacyUrl);
}
