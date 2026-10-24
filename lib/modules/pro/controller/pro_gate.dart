import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_routes.dart';
import 'pro_controller.dart';

/// Runs [onAllowed] straight away for Pro users. Free users see the
/// paywall first, and the action runs only if they upgrade.
class ProGate {
  static Future<void> run(BuildContext context, VoidCallback onAllowed) async {
    final proController = context.read<ProController>();
    if (proController.isPro) {
      onAllowed();
      return;
    }
    final upgraded = await Navigator.of(context).pushNamed(AppRoutes.paywall);
    if (upgraded == true && context.mounted) onAllowed();
  }
}
