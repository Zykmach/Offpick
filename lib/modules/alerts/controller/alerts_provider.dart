import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../routes/route_arguments.dart';
import '../view/alert_created_screen.dart';
import 'alerts_controller.dart';

class AlertsProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(
      create: (context) => AlertsController(
        repository: context.read(),
        notificationService: context.read(),
      ),
    );
  }

  static Widget createdScreen(AlertCreatedArgs args) => AlertCreatedScreen(args: args);
}
