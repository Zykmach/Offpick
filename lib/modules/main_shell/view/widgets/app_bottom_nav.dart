import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NavItem {
  final IconData icon;
  final String label;

  const NavItem(this.icon, this.label);
}

/// Home · Categories · Compare · Alerts · Me
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int alertsBadge;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap, this.alertsBadge = 0});

  static const List<NavItem> items = [
    NavItem(LucideIcons.house, 'Home'),
    NavItem(LucideIcons.layoutGrid, 'Categories'),
    NavItem(LucideIcons.arrowLeftRight, 'Compare'),
    NavItem(LucideIcons.bell, 'Alerts'),
    NavItem(LucideIcons.user, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;
              final showBadge = index == 3 && alertsBadge > 0 && !isActive;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        width: isActive ? 56 : 44,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.lime : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedScale(
                              scale: isActive ? 1.08 : 1,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                item.icon,
                                size: 22,
                                color: isActive ? AppColors.onLime : colors.textSecondary,
                              ),
                            ),
                            if (showBadge)
                              Positioned(
                                top: 3,
                                right: 10,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: colors.warning, shape: BoxShape.circle),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: AppTextStyles.captionMedium.copyWith(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? colors.textPrimary : colors.textSecondary,
                        ),
                        child: Text(item.label, maxLines: 1),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
