import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/feature_row.dart';
import '../../../core/widgets/layout_widgets.dart';
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
            return FillOrScroll(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FadeSlideIn(child: AppLogoMark(size: 56)),
                  const SizedBox(height: 22),
                  FadeSlideIn(
                    index: 1,
                    child: Text('Welcome to Offpick', style: AppTextStyles.display),
                  ),
                  const SizedBox(height: 6),
                  FadeSlideIn(
                    index: 2,
                    child: Text(
                      'Log in to save offers and get deal alerts.',
                      style: AppTextStyles.body.copyWith(color: colors.textSecondary),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 28),
                  const FadeSlideIn(index: 3, child: LoginBenefits()),
                  const Spacer(),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    index: 4,
                    child: AppButton(
                      label: 'Continue with Google',
                      leading: const GoogleBadge(),
                      isLoading: controller.isLoading,
                      onPressed: () => continueWithGoogle(context, controller),
                    ),
                  ),
                  FormError(controller.errorMessage),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Free to use · No spam, ever',
                      style: AppTextStyles.captionMedium.copyWith(color: colors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 16),
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

/// What you get by logging in, shown in the middle of the login screen.
class LoginBenefits extends StatelessWidget {
  const LoginBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border, width: 1.2),
      ),
      child: const Column(
        children: [
          FeatureRow(
            icon: LucideIcons.badgePercent,
            title: 'Live deals from top brands',
            message: 'Fresh coupons and offers, updated all day.',
          ),
          FeatureRow(
            icon: LucideIcons.bellRing,
            title: 'Alerts that matter',
            message: 'Know the moment a deal you like goes live.',
          ),
          FeatureRow(
            icon: LucideIcons.heart,
            title: 'Save for later',
            message: 'Your saved offers follow you to any phone.',
          ),
        ],
      ),
    );
  }
}
