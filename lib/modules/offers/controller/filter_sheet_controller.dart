import 'package:flutter/foundation.dart';

import '../model/offer_filter_model.dart';

/// Holds the choices inside the filter sheet until the user taps Apply.
class FilterSheetController extends ChangeNotifier {
  OfferFilterModel filter;

  FilterSheetController(this.filter);

  static const List<int> discountSteps = [0, 30, 50, 70];

  void setSort(OfferSort sort) {
    filter = filter.copyWith(sort: sort);
    notifyListeners();
  }

  void setMinDiscount(int value) {
    filter = filter.copyWith(minDiscount: value);
    notifyListeners();
  }

  void toggleStore(String storeId) {
    final stores = {...filter.storeIds};
    if (!stores.remove(storeId)) stores.add(storeId);
    filter = filter.copyWith(storeIds: stores);
    notifyListeners();
  }

  void reset() {
    filter = const OfferFilterModel();
    notifyListeners();
  }
}
