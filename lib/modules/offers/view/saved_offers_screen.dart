import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../main_shell/controller/main_shell_controller.dart';
import '../controller/saved_offers_controller.dart';
import 'widgets/offer_list_tile.dart';
import 'widgets/save_offer_button.dart';

class SavedOffersScreen extends StatelessWidget {
  const SavedOffersScreen({super.key});

  void browseOffers(BuildContext context) {
    context.read<MainShellController>().setTab(MainShellController.homeTab);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SavedOffersController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                ScreenHeader(
                  title: 'Saved offers',
                  subtitle: '${controller.count} saved',
                ),
                Expanded(
                  child: controller.isLoading && controller.savedOffers.isEmpty
                      ? const AppLoader()
                      : controller.savedOffers.isEmpty
                          ? EmptyState(
                              icon: LucideIcons.heart,
                              title: 'Nothing saved yet',
                              message: 'Tap the heart on any offer to keep it here.',
                              action: AppButton(
                                label: 'Browse offers',
                                expand: false,
                                onPressed: () => browseOffers(context),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                              itemCount: controller.savedOffers.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final offer = controller.savedOffers[index];
                                return FadeSlideIn(
                                  key: ValueKey(offer.id),
                                  index: index,
                                  child: OfferListTile(
                                    offer: offer,
                                    trailing: SaveOfferButton(offer: offer, size: 34, bordered: true),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
