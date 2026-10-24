import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/pressable.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String details;
  final VoidCallback onEdit;

  const ProfileHeader({super.key, required this.name, required this.details, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
          child: Text(
            Formatters.initials(name),
            style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w800, color: AppColors.onLime),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.heading2.copyWith(fontSize: 26)),
              Text(details, style: AppTextStyles.body.copyWith(fontSize: 16, color: colors.textSecondary)),
            ],
          ),
        ),
        CircleIconButton(icon: LucideIcons.pencil, onTap: onEdit),
      ],
    );
  }
}

/// Dark "Get Offpick Pro" banner, or a soft one when the user already has Pro.
class UpgradeBanner extends StatelessWidget {
  final bool isPro;
  final VoidCallback onTap;

  const UpgradeBanner({super.key, required this.isPro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = isPro ? colors.limeSoft : colors.inverse;
    final foreground = isPro ? colors.textPrimary : colors.onInverse;

    return Pressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(16)),
              child: const Icon(LucideIcons.crown, color: AppColors.onLime),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPro ? "You're on Offpick Pro" : 'Get Offpick Pro',
                    style: AppTextStyles.title.copyWith(fontSize: 19, color: foreground),
                  ),
                  Text(
                    isPro ? 'Compare and alerts are unlocked' : 'Unlock price comparison and alerts',
                    style: AppTextStyles.body.copyWith(color: foreground.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            if (!isPro)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(14)),
                child: Text('Upgrade', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16, color: AppColors.onLime)),
              ),
          ],
        ),
      ),
    );
  }
}

/// White rounded group of setting rows.
class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.border, width: 1.2),
      ),
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) Divider(height: 1, color: colors.border),
            children[index],
          ],
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;
  final bool isDanger;
  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.isDanger = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isDanger ? colors.warning : colors.textPrimary;

    return InkWell(
      onTap: onTap,
      splashColor: colors.surfaceMuted,
      highlightColor: colors.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontSize: 17, color: color))),
            if (value != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  value!,
                  key: ValueKey(value),
                  style: AppTextStyles.body.copyWith(fontSize: 16, color: colors.textSecondary),
                ),
              ),
            if (showChevron && !isDanger) ...[
              const SizedBox(width: 12),
              Icon(LucideIcons.chevronRight, size: 20, color: colors.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
