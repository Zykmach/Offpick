import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../controller/filter_sheet_controller.dart';
import '../../model/offer_filter_model.dart';
import '../../model/store_model.dart';

/// Opens the filter sheet and returns the new filter, or null if closed.
Future<OfferFilterModel?> showFilterSheet(
  BuildContext context, {
  required OfferFilterModel current,
  required List<StoreModel> stores,
}) {
  return showAppSheet<OfferFilterModel>(
    context,
    builder: (sheetContext) => ChangeNotifierProvider(
      create: (context) => FilterSheetController(current),
      child: FilterSheet(stores: stores),
    ),
  );
}

class FilterSheet extends StatelessWidget {
  final List<StoreModel> stores;

  const FilterSheet({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleStyle = AppTextStyles.bodySemiBold.copyWith(color: colors.textSecondary);

    return Consumer<FilterSheetController>(
      builder: (context, controller, child) {
        final filter = controller.filter;
        return SheetLayout(
          title: 'Filters',
          footer: Row(
            children: [
              Expanded(
                child: AppButton(label: 'Reset', type: AppButtonType.outline, onPressed: controller.reset),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppButton(label: 'Apply', onPressed: () => Navigator.of(context).pop(filter)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sort by', style: titleStyle),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final sort in OfferSort.values)
                    PillChip(
                      label: sort.label,
                      selected: filter.sort == sort,
                      onTap: () => controller.setSort(sort),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Text('Minimum discount', style: titleStyle),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final step in FilterSheetController.discountSteps)
                    PillChip(
                      label: step == 0 ? 'Any' : '$step%+ off',
                      selected: filter.minDiscount == step,
                      onTap: () => controller.setMinDiscount(step),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Text('Stores', style: titleStyle),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final store in stores)
                    PillChip(
                      label: store.name,
                      style: PillChipStyle.outline,
                      selected: filter.storeIds.contains(store.id),
                      onTap: () => controller.toggleStore(store.id),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
