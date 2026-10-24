import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/home_repository.dart';
import '../model/comparison_model.dart';
import '../model/store_price_model.dart';
import 'compare_controller.dart';

/// "Compare prices" for one product.
class ComparePricesController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final CompareController compareController;
  final String offerId;

  ComparisonModel? comparison;
  String? selectedStoreId;
  bool isLoading = true;
  String? errorMessage;

  ComparePricesController({required this.homeRepository, required this.compareController, required this.offerId});

  /// The store the bottom button will open. Defaults to the cheapest.
  StorePriceModel? get selected {
    final current = comparison;
    if (current == null) return null;
    return current.prices.firstWhere((item) => item.storeId == selectedStoreId, orElse: () => current.best);
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      comparison = await homeRepository.fetchComparison(offerId);
      selectedStoreId = comparison!.best.storeId;
      compareController.track(comparison!);
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  void selectStore(String storeId) {
    selectedStoreId = storeId;
    notifyListeners();
  }
}
