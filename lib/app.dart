import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'modules/profile/controller/theme_controller.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'services/notification_service.dart';

class OffpickApp extends StatelessWidget {
  const OffpickApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = context.read<NotificationService>();

    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,
          themeAnimationDuration: const Duration(milliseconds: 350),
          scaffoldMessengerKey: notificationService.messengerKey,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.generate,
        );
      },
    );
  }
}
