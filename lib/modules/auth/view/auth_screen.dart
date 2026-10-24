import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../controller/login_controller.dart';
import 'widgets/auth_widgets.dart';

/// Sign in is one tap: Continue with Google.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> continueWithGoogle(BuildContext context, LoginController controller) async {
    final success = await controller.continueWithGoogle();
    if (success && context.mounted) {
      final nextRoute = controller.authController.routeAfterLogin;
      Navigator.of(context).pushNamedAndRemoveUntil(nextRoute, (oldRoute) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Consumer<LoginController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FadeSlideIn(child: AppLogoMark(size: 64)),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    index: 1,
                    child: Text('Welcome to Offpick', style: AppTextStyles.heading1.copyWith(fontSize: 32)),
                  ),
                  const SizedBox(height: 8),
                  FadeSlideIn(
                    index: 2,
                    child: Text(
                      'Log in to save offers and get deal alerts.',
                      style: AppTextStyles.body.copyWith(fontSize: 17, color: colors.textSecondary),
                    ),
                  ),
                  const Spacer(),
                  FadeSlideIn(
                    index: 3,
                    child: AppButton(
                      label: 'Continue with Google',
                      leading: const GoogleBadge(),
                      isLoading: controller.isLoading,
                      onPressed: () => continueWithGoogle(context, controller),
                    ),
                  ),
                  FormError(controller.errorMessage),
                  const SizedBox(height: 24),
                  TermsText(onTerms: controller.openTerms, onPrivacy: controller.openPrivacy),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
