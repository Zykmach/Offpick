import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pressable.dart';
import '../../model/offer_model.dart';

/// Coupon code with a copy button, plus the deal's details and terms.
class DealInfoCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onCopyCode;

  const DealInfoCard({super.key, required this.offer, required this.onCopyCode});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (offer.hasCoupon) ...[
            Text('Use this code at checkout', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
            const SizedBox(height: 10),
            Pressable(
              onTap: onCopyCode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.accent, width: 1.2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        offer.couponCode,
                        style: AppTextStyles.heading3.copyWith(letterSpacing: 1.5, color: colors.accent),
                      ),
                    ),
                    Icon(LucideIcons.copy, size: 18, color: colors.accent),
                    const SizedBox(width: 6),
                    Text('Copy', style: AppTextStyles.bodySemiBold.copyWith(color: colors.accent)),
                  ],
                ),
              ),
            ),
          ],
          if (offer.hasCoupon && offer.description.isNotEmpty) const SizedBox(height: 14),
          if (offer.description.isNotEmpty)
            Text(offer.description, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
          if (offer.terms.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              offer.terms,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
