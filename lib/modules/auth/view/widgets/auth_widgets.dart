import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// White circle with a "G", shown inside the Google button.
class GoogleBadge extends StatelessWidget {
  const GoogleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Text('G', style: AppTextStyles.tag.copyWith(fontSize: 14, color: AppColors.onLime)),
    );
  }
}

/// "By continuing you agree to our Terms and Privacy Policy."
class TermsText extends StatelessWidget {
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  const TermsText({super.key, required this.onTerms, required this.onPrivacy});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final linkStyle = AppTextStyles.captionMedium.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600);
    return Text.rich(
      TextSpan(
        style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
        children: [
          const TextSpan(text: 'By continuing you agree to our '),
          TextSpan(text: 'Terms', style: linkStyle, recognizer: TapGestureRecognizer()..onTap = onTerms),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: linkStyle, recognizer: TapGestureRecognizer()..onTap = onPrivacy),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Orange error line under a form.
class FormError extends StatelessWidget {
  final String? message;

  const FormError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: message == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.captionMedium.copyWith(color: context.colors.warning),
              ),
            ),
    );
  }
}
