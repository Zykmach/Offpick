import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/on_init.dart';
import '../../alerts/controller/alerts_controller.dart';
import '../../alerts/view/alerts_screen.dart';
import '../../categories/controller/categories_controller.dart';
import '../../categories/view/categories_screen.dart';
import '../../compare/controller/compare_controller.dart';
import '../../compare/view/compare_screen.dart';
import '../../home/controller/home_controller.dart';
import '../../home/view/home_screen.dart';
import '../../offers/controller/saved_offers_controller.dart';
import '../../pro/controller/pro_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/view/profile_screen.dart';
import '../controller/main_shell_controller.dart';
import 'widgets/app_bottom_nav.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  static const List<Widget> tabs = [
    HomeScreen(),
    CategoriesScreen(),
    CompareScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  /// Loads everything the tabs need once the user lands here.
  void loadData(BuildContext context) {
    context.read<MainShellController>().reset();
    context.read<HomeController>().load(refresh: true);
    context.read<CategoriesController>().load();
    context.read<SavedOffersController>().load();
    context.read<CompareController>().load();
    context.read<AlertsController>().load();
    context.read<ProController>().refresh();
    context.read<ProfileController>().refreshCounts();
  }

  @override
  Widget build(BuildContext context) {
    return OnInit(
      onInit: loadData,
      child: Consumer2<MainShellController, AlertsController>(
        builder: (context, shell, alerts, child) {
          return Scaffold(
            body: Stack(
              children: List.generate(tabs.length, (index) {
                final isActive = index == shell.currentTab;
                // Every tab stays alive so scroll position is kept,
                // only the active one is visible and touchable.
                return IgnorePointer(
                  ignoring: !isActive,
                  child: AnimatedOpacity(
                    opacity: isActive ? 1 : 0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    child: AnimatedSlide(
                      offset: isActive ? Offset.zero : const Offset(0, 0.02),
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      child: TickerMode(enabled: isActive, child: tabs[index]),
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: AppBottomNav(
              currentIndex: shell.currentTab,
              alertsBadge: alerts.unreadCount,
              onTap: shell.setTab,
            ),
          );
        },
      ),
    );
  }
}
