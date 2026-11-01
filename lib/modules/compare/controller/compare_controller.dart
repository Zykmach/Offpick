import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/home_repository.dart';
import '../../../repositories/user_data_repository.dart';
import '../model/comparison_model.dart';

/// Products the user is tracking in the Compare tab.
class CompareController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final UserDataRepository userDataRepository;

  List<String> trackedIds = [];
  List<ComparisonModel> comparisons = [];
  bool isLoading = false;
  String? errorMessage;

  CompareController({required this.homeRepository, required this.userDataRepository});

  /// Money saved by buying at the best store instead of where it was found.
  int get totalSaved => comparisons.fold(0, (sum, item) => sum + item.savingVsViewing);

  Future<void> load() async {
    isLoading = comparisons.isEmpty;
    errorMessage = null;
    notifyListeners();
    try {
      trackedIds = await userDataRepository.fetchTrackedIds();
      final results = await Future.wait(trackedIds.map(homeRepository.comparisonOrNull));
      comparisons = results.whereType<ComparisonModel>().toList();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  /// Called when the user opens "Compare prices" for an offer.
  Future<void> track(ComparisonModel comparison) async {
    if (trackedIds.contains(comparison.offerId)) return;
    trackedIds = [comparison.offerId, ...trackedIds];
    comparisons = [comparison, ...comparisons];
    notifyListeners();
    await userDataRepository.saveTrackedIds(trackedIds);
  }

  Future<void> remove(String offerId) async {
    trackedIds = trackedIds.where((id) => id != offerId).toList();
    comparisons = comparisons.where((item) => item.offerId != offerId).toList();
    notifyListeners();
    await userDataRepository.saveTrackedIds(trackedIds);
  }
}
