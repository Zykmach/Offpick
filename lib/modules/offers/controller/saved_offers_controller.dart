import 'package:flutter/foundation.dart';

import '../../../repositories/home_repository.dart';
import '../../../repositories/user_data_repository.dart';
import '../model/offer_model.dart';

/// Offers the user tapped the heart on.
class SavedOffersController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final UserDataRepository userDataRepository;

  List<String> savedIds = [];
  List<OfferModel> savedOffers = [];
  bool isLoading = false;

  SavedOffersController({required this.homeRepository, required this.userDataRepository});

  int get count => savedIds.length;

  bool isSaved(String offerId) => savedIds.contains(offerId);

  Future<void> load() async {
    savedIds = userDataRepository.savedOfferIds;
    isLoading = true;
    notifyListeners();
    savedOffers = await homeRepository.offersByIds(savedIds);
    isLoading = false;
    notifyListeners();
  }

  /// Returns true when the offer is now saved.
  Future<bool> toggle(OfferModel offer) async {
    final nowSaved = !isSaved(offer.id);
    if (nowSaved) {
      savedIds = [offer.id, ...savedIds];
      savedOffers = [offer, ...savedOffers];
    } else {
      savedIds = savedIds.where((id) => id != offer.id).toList();
      savedOffers = savedOffers.where((item) => item.id != offer.id).toList();
    }
    notifyListeners();
    await userDataRepository.saveOfferIds(savedIds);
    return nowSaved;
  }
}
