import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/form_controls.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/loading_dots.dart';
import '../../../core/widgets/on_init.dart';
import '../../offers/view/widgets/product_info_cards.dart';
import '../controller/redirect_controller.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key});

  Future<void> start(BuildContext context) async {
    final controller = context.read<RedirectController>();
    final opened = await controller.start();
    if (context.mounted) afterOpen(context, controller, opened);
  }

  Future<void> openNow(BuildContext context, RedirectController controller) async {
    controller.cancel();
    final opened = await controller.openStore();
    if (context.mounted) afterOpen(context, controller, opened);
  }

  void afterOpen(BuildContext context, RedirectController controller, bool opened) {
    if (!context.mounted || controller.isCancelled && !opened) return;
    if (!opened) {
      AppMessages.show(context, 'Could not open ${controller.storeName}. Please try again.');
      return;
    }
    Navigator.of(context).maybePop();
  }

  void stay(BuildContext context, RedirectController controller) {
    controller.cancel();
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return OnInit(
      onInit: start,
      child: Scaffold(
        body: SafeArea(
          child: Consumer<RedirectController>(
            builder: (context, controller, child) {
              final offer = controller.offer;
              final monogram = controller.store?.monogram ?? '';

              return FillOrScroll(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleIconButton(icon: LucideIcons.x, onTap: () => stay(context, controller)),
                    ),
                    const Spacer(),
                    FadeSlideIn(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: colors.border),
                            ),
                            alignment: Alignment.center,
                            child: const AppLogoMark(size: 48),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: LoadingDots(size: 8)),
                          PopIn(
                            child: Container(
                              width: 76,
                              height: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(24)),
                              child: Text(
                                monogram,
                                style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.w800, color: AppColors.onLime),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeSlideIn(
                      index: 1,
                      child: Text(
                        'Taking you to ${controller.storeName}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeSlideIn(
                      index: 2,
                      child: Text(
                        "Complete your purchase on the store.\nWe'll keep watching prices for you.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(fontSize: 15, color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (offer != null)
                      FadeSlideIn(
                        index: 3,
                        child: AppCard(
                          padding: const EdgeInsets.all(12),
                          child: ProductSummaryRow(
                            iconKey: offer.iconKey,
                            tint: offer.tint,
                            title: offer.title,
                            subtitle: '${controller.isBestPrice ? 'Best price found' : 'Live offer'} · '
                                '${controller.discountPercent > 0 ? '${controller.discountPercent}% off' : offer.dealLabel}',
                            trailing: controller.price == null
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Text(Formatters.price(controller.price!), style: AppTextStyles.price),
                                  ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 28),
                    AppProgressBar(value: controller.progress, width: 160, duration: const Duration(milliseconds: 60)),
                    const Spacer(),
                    Text(
                      'Final price and stock are confirmed by ${controller.storeName} at checkout.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(fontSize: 13, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Open ${controller.storeName} now',
                      trailingIcon: LucideIcons.externalLink,
                      onPressed: () => openNow(context, controller),
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'Stay on Offpick',
                      type: AppButtonType.text,
                      onPressed: () => stay(context, controller),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
