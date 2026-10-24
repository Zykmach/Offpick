import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/catalog_repository.dart';
import '../../../repositories/preferences_repository.dart';
import '../../offers/model/store_model.dart';
import '../model/interest_model.dart';

/// "What do you shop for?" – used after sign up and from the Me tab.
class InterestsController extends ChangeNotifier {
  final CatalogRepository catalogRepository;
  final PreferencesRepository preferences;
  final bool isEditing;

  List<InterestModel> interests = [];
  List<StoreModel> stores = [];
  Set<String> selectedInterestIds = {};
  Set<String> selectedStoreIds = {};
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  InterestsController({required this.catalogRepository, required this.preferences, required this.isEditing});

  int get selectedCount => selectedInterestIds.length;

  bool get canContinue => selectedCount > 0 && !isSaving;

  String get buttonLabel {
    if (isEditing) return 'Save changes';
    if (selectedCount == 0) return 'Pick at least one';
    return 'Continue · $selectedCount selected';
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      interests = await catalogRepository.fetchInterests();
      final allStores = await catalogRepository.fetchStores();
      stores = allStores.where((store) => store.featured).toList();
      selectedInterestIds = preferences.interestIds.toSet();
      selectedStoreIds = preferences.storeIds.toSet();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  void toggleInterest(String id) {
    selectedInterestIds = {...selectedInterestIds};
    if (!selectedInterestIds.remove(id)) selectedInterestIds.add(id);
    notifyListeners();
  }

  void toggleStore(String id) {
    selectedStoreIds = {...selectedStoreIds};
    if (!selectedStoreIds.remove(id)) selectedStoreIds.add(id);
    notifyListeners();
  }

  Future<void> save() async {
    isSaving = true;
    notifyListeners();
    await preferences.saveInterestIds(selectedInterestIds.toList());
    await preferences.saveStoreIds(selectedStoreIds.toList());
    await preferences.setPickedInterests(true);
    isSaving = false;
    notifyListeners();
  }

  Future<void> skip() => preferences.setPickedInterests(true);
}
