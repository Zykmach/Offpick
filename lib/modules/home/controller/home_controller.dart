import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/catalog_repository.dart';
import '../../../repositories/home_repository.dart';
import '../../../repositories/preferences_repository.dart';
import '../../interests/model/interest_model.dart';
import '../../offers/model/offer_model.dart';
import '../model/home_chip_model.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final CatalogRepository catalogRepository;
  final PreferencesRepository preferences;

  List<OfferModel> offers = [];
  List<InterestModel> myInterests = [];
  String selectedChipId = HomeChipModel.forYou;
  bool isLoading = false;
  String? errorMessage;

  HomeController({
    required this.homeRepository,
    required this.catalogRepository,
    required this.preferences,
  });

  List<HomeChipModel> get chips => HomeChipModel.all;

  /// Live offers for the selected chip. "For you" puts the user's
  /// interests first, then everything else, newest first.
  List<OfferModel> get feed {
    final now = DateTime.now();
    final live = offers.where((offer) => offer.isLiveAt(now)).toList()
      ..sort((first, second) => second.startedAt.compareTo(first.startedAt));

    if (selectedChipId != HomeChipModel.forYou) {
      return live.where((offer) => offer.categoryId == selectedChipId).toList();
    }
    if (myInterests.isEmpty) return live;

    bool isMine(OfferModel offer) => myInterests.any((interest) => interest.matches(offer));
    return [...live.where(isMine), ...live.where((offer) => !isMine(offer))];
  }

  Future<void> load({bool refresh = false}) async {
    if (offers.isNotEmpty && !refresh) return;
    isLoading = offers.isEmpty;
    errorMessage = null;
    notifyListeners();
    try {
      offers = await homeRepository.fetchOffers(refresh: refresh);
      await reloadInterests();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load(refresh: true);

  Future<void> reloadInterests() async {
    final all = await catalogRepository.fetchInterests();
    final ids = preferences.interestIds;
    myInterests = all.where((interest) => ids.contains(interest.id)).toList();
    notifyListeners();
  }

  void selectChip(String chipId) {
    if (selectedChipId == chipId) return;
    selectedChipId = chipId;
    notifyListeners();
  }
}
