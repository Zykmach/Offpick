import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_logo.dart';

/// Shows an in-app banner that looks like a phone notification.
/// Push notifications (FCM / APNs) can be plugged in here later.
class NotificationService {
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  bool isEnabled = true;

  void showBanner({required String title, required String body}) {
    final messenger = messengerKey.currentState;
    if (messenger == null || !isEnabled) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 90),
          duration: const Duration(seconds: 4),
          content: NotificationBanner(title: title, body: body),
        ),
      );
  }
}

class NotificationBanner extends StatelessWidget {
  final String title;
  final String body;

  const NotificationBanner({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: const Color(0xFF0F1510), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: const AppLogoMark(size: 34),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySemiBold.copyWith(color: colors.textPrimary)),
                const SizedBox(height: 2),
                Text(body, style: AppTextStyles.caption.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
