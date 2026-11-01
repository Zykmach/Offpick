import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/form_controls.dart';
import '../../../core/widgets/pressable.dart';
import '../../../routes/app_routes.dart';
import '../controller/onboarding_controller.dart';
import 'widgets/welcome_preview.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static final DateTime demoEndsAt = DateTime.now().add(const Duration(hours: 2, minutes: 14, seconds: 36));

  Future<void> goToAuth(BuildContext context, OnboardingController controller) async {
    await controller.finish();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 28, 0),
                    child: Pressable(
                      onTap: () => goToAuth(context, controller),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15, color: colors.textSecondary),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.pages.length,
                    itemBuilder: (context, index) {
                      final page = controller.pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                // The preview is an illustration: it scales as one picture
                                // and ignores the phone's text size.
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: MediaQuery.withNoTextScaling(
                                    child: WelcomePreview(pageIndex: index, demoEndsAt: demoEndsAt),
                                  ),
                                ),
                              ),
                            ),
                            FadeSlideIn(
                              index: 2,
                              child: Text(
                                '${page.titleLineOne}\n${page.titleLineTwo}',
                                style: AppTextStyles.display.copyWith(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FadeSlideIn(
                              index: 3,
                              child: Text(
                                page.message,
                                style: AppTextStyles.body.copyWith(fontSize: 15, color: colors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageDots(count: controller.pages.length, current: controller.currentPage),
                      const SizedBox(height: 22),
                      AppButton(label: 'Get started', onPressed: () => goToAuth(context, controller)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
