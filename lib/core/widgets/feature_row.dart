import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Icon in a soft square, a bold title and a short message under it.
class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const FeatureRow({super.key, required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: colors.limeSoft, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 22, color: colors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(message, style: AppTextStyles.body.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
