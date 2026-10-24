import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_messages.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../../offers/controller/saved_offers_controller.dart';
import '../../pro/controller/pro_controller.dart';
import '../controller/profile_controller.dart';
import '../controller/theme_controller.dart';
import 'profile_sheets.dart';
import 'widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> contactSupport(BuildContext context, ProfileController controller) async {
    final opened = await controller.contactSupport();
    if (!opened && context.mounted) AppMessages.show(context, 'Write to us at support@offpick.app');
  }

  Future<void> logout(BuildContext context) async {
    final confirmed = await AppMessages.confirm(
      context,
      title: 'Log out?',
      message: 'Your saved offers and alerts on this phone will be cleared.',
      confirmLabel: 'Log out',
    );
    if (!confirmed || !context.mounted) return;
    await context.read<AuthController>().logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.auth, (oldRoute) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Consumer5<ProfileController, AuthController, ProController, SavedOffersController, ThemeController>(
        builder: (context, profile, auth, pro, saved, theme, child) {
          final user = auth.user;
          final name = user?.name ?? 'Offpick shopper';
          final contact = user?.contact ?? '';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              FadeSlideIn(
                child: ProfileHeader(
                  name: name,
                  details: contact.isEmpty ? pro.planLabel : '$contact · ${pro.planLabel}',
                  onEdit: () => showEditProfileSheet(context),
                ),
              ),
              const SizedBox(height: 18),
              FadeSlideIn(
                index: 1,
                child: UpgradeBanner(
                  isPro: pro.isPro,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.paywall),
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                index: 2,
                child: SettingsGroup(
                  children: [
                    SettingsTile(
                      icon: LucideIcons.heart,
                      title: 'Saved offers',
                      value: '${saved.count}',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.savedOffers),
                    ),
                    SettingsTile(
                      icon: LucideIcons.sparkles,
                      title: 'My interests',
                      value: '${profile.interestCount}',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.interests, arguments: true),
                    ),
                    SettingsTile(
                      icon: LucideIcons.store,
                      title: 'Preferred stores',
                      value: '${profile.storeCount}',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.interests, arguments: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                index: 3,
                child: SettingsGroup(
                  children: [
                    SettingsTile(
                      icon: profile.notificationsOn ? LucideIcons.bell : LucideIcons.bellOff,
                      title: 'Notifications',
                      value: profile.notificationsOn ? 'On' : 'Off',
                      onTap: profile.toggleNotifications,
                    ),
                    SettingsTile(
                      icon: LucideIcons.moon,
                      title: 'Appearance',
                      value: theme.label,
                      onTap: () => showAppearanceSheet(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                index: 4,
                child: SettingsGroup(
                  children: [
                    SettingsTile(
                      icon: LucideIcons.circleHelp,
                      title: 'Help & support',
                      onTap: () => contactSupport(context, profile),
                    ),
                    SettingsTile(
                      icon: LucideIcons.logOut,
                      title: 'Log out',
                      isDanger: true,
                      onTap: () => logout(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
