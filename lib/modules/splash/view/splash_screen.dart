import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/form_controls.dart';
import '../../../core/widgets/on_init.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> startApp(BuildContext context) async {
    final nextRoute = await context.read<SplashController>().start();
    if (context.mounted) Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return OnInit(
      onInit: startApp,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              const Spacer(),
              const PopIn(from: 0.7, duration: Duration(milliseconds: 1100), child: AppWordmark(fontSize: 56)),
              const SizedBox(height: 28),
              FadeSlideIn(
                index: 4,
                delayStep: const Duration(milliseconds: 100),
                child: Text(
                  AppConstants.tagline,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 17,
                    letterSpacing: 6,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Consumer<SplashController>(
                builder: (context, controller, child) => AppProgressBar(
                  value: controller.progress,
                  width: 120,
                  duration: const Duration(milliseconds: 1400),
                ),
              ),
              const SizedBox(height: 22),
              FadeSlideIn(
                index: 6,
                child: Text(
                  "Finding today's live offers",
                  style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
                ),
              ),
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
