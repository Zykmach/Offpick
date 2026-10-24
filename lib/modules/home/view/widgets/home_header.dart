import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/pressable.dart';

/// Logo, bell and the search bar at the top of Home.
class HomeHeader extends StatelessWidget {
  final bool hasUnread;
  final VoidCallback onBellTap;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const HomeHeader({
    super.key,
    required this.hasUnread,
    required this.onBellTap,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              const AppWordmark(fontSize: 32),
              const Spacer(),
              CircleIconButton(icon: LucideIcons.bell, showDot: hasUnread, onTap: onBellTap),
            ],
          ),
          const SizedBox(height: 12),
          Pressable(
            pressedScale: 0.98,
            onTap: onSearchTap,
            child: Container(
              height: 60,
              padding: const EdgeInsets.only(left: 18, right: 6),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: colors.border, width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.search, size: 22, color: colors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search shirts, phones, brands...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(fontSize: 16, color: colors.textMuted),
                    ),
                  ),
                  Pressable(
                    onTap: onFilterTap,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: BorderRadius.circular(14)),
                      child: Icon(LucideIcons.slidersHorizontal, size: 20, color: colors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
