import 'offer_model.dart';

enum OfferSort {
  newest('Newest'),
  biggestDiscount('Biggest discount'),
  endingSoon('Ending soon'),
  lowestPrice('Lowest price');

  final String label;
  const OfferSort(this.label);
}

/// Everything the user picked in the sort chips and the filter sheet.
class OfferFilterModel {
  final OfferSort sort;
  final int minDiscount;
  final Set<String> storeIds;

  const OfferFilterModel({
    this.sort = OfferSort.newest,
    this.minDiscount = 0,
    this.storeIds = const {},
  });

  int get activeCount => (minDiscount > 0 ? 1 : 0) + (storeIds.isNotEmpty ? 1 : 0);

  OfferFilterModel copyWith({OfferSort? sort, int? minDiscount, Set<String>? storeIds}) {
    return OfferFilterModel(
      sort: sort ?? this.sort,
      minDiscount: minDiscount ?? this.minDiscount,
      storeIds: storeIds ?? this.storeIds,
    );
  }

  List<OfferModel> apply(List<OfferModel> offers) {
    final result = offers.where((offer) {
      final passesDiscount = offer.discountPercent >= minDiscount;
      final passesStore = storeIds.isEmpty || storeIds.contains(offer.storeId);
      return passesDiscount && passesStore;
    }).toList();

    switch (sort) {
      case OfferSort.newest:
        result.sort((first, second) => second.startedAt.compareTo(first.startedAt));
      case OfferSort.biggestDiscount:
        result.sort((first, second) => second.discountPercent.compareTo(first.discountPercent));
      case OfferSort.endingSoon:
        result.sort((first, second) => first.endsAt.compareTo(second.endsAt));
      case OfferSort.lowestPrice:
        // Deals without a product price go to the end.
        result.sort((first, second) => (first.price ?? 1 << 30).compareTo(second.price ?? 1 << 30));
    }
    return result;
  }
}
