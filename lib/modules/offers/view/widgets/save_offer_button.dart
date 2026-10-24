import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_messages.dart';
import '../../../../core/widgets/pressable.dart';
import '../../controller/saved_offers_controller.dart';
import '../../model/offer_model.dart';

/// Round heart button. Filled when the offer is saved.
class SaveOfferButton extends StatelessWidget {
  final OfferModel offer;
  final double size;
  final bool bordered;

  const SaveOfferButton({super.key, required this.offer, this.size = 46, this.bordered = false});

  Future<void> toggle(BuildContext context, SavedOffersController controller) async {
    final isSaved = await controller.toggle(offer);
    if (context.mounted) {
      AppMessages.show(context, isSaved ? 'Saved to your offers' : 'Removed from saved offers');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<SavedOffersController>(
      builder: (context, controller, child) {
        final isSaved = controller.isSaved(offer.id);
        return Pressable(
          pressedScale: 0.85,
          onTap: () => toggle(context, controller),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
              border: bordered ? Border.all(color: colors.border) : null,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                child: child,
              ),
              child: isSaved
                  ? Icon(Icons.favorite_rounded, key: const ValueKey('saved'), size: size * 0.5, color: colors.warning)
                  : Icon(LucideIcons.heart, key: const ValueKey('not-saved'), size: size * 0.48, color: colors.textPrimary),
            ),
          ),
        );
      },
    );
  }
}
