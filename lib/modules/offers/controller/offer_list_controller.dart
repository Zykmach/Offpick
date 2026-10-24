import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/catalog_repository.dart';
import '../../../repositories/home_repository.dart';
import '../../../routes/route_arguments.dart';
import '../../categories/model/subcategory_model.dart';
import '../model/offer_filter_model.dart';
import '../model/offer_model.dart';
import '../model/store_model.dart';

/// List of live offers for a subcategory, a category or everything.
class OfferListController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final CatalogRepository catalogRepository;
  final OfferListArgs args;

  List<OfferModel> offers = [];
  List<StoreModel> stores = [];
  SubcategoryModel? subcategory;
  String categoryName = '';
  OfferFilterModel filter = const OfferFilterModel();
  bool isLoading = true;
  String? errorMessage;

  OfferListController({required this.homeRepository, required this.catalogRepository, required this.args});

  String get title {
    if (args.title != null) return args.title!;
    if (subcategory != null) return subcategory!.fullName;
    if (args.groupId.isNotEmpty) {
      return "${args.groupId[0].toUpperCase()}${args.groupId.substring(1)}'s $categoryName";
    }
    return categoryName.isEmpty ? 'Offers' : categoryName;
  }

  /// The catalog count when we know it, otherwise what we loaded.
  int get liveCount => subcategory?.offerCount ?? visibleOffers.length;

  List<OfferModel> get visibleOffers {
    final now = DateTime.now();
    return filter.apply(offers.where((offer) => offer.isLiveAt(now)).toList());
  }

  Future<void> load({bool refresh = false}) async {
    isLoading = offers.isEmpty;
    errorMessage = null;
    notifyListeners();
    try {
      stores = await catalogRepository.fetchStores();
      if (args.subcategoryId != null) {
        subcategory = await catalogRepository.subcategoryById(args.subcategoryId!);
      }
      final categoryId = args.categoryId ?? subcategory?.categoryId;
      if (categoryId != null) {
        categoryName = (await catalogRepository.categoryById(categoryId))?.name ?? '';
      }

      final all = await homeRepository.fetchOffers(refresh: refresh);
      offers = all.where((offer) {
        if (args.subcategoryId != null) return offer.subcategoryId == args.subcategoryId;
        if (args.categoryId != null && offer.categoryId != args.categoryId) return false;
        if (args.groupId.isNotEmpty && offer.groupId != args.groupId) return false;
        return true;
      }).toList();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load(refresh: true);

  void setSort(OfferSort sort) {
    filter = filter.copyWith(sort: sort);
    notifyListeners();
  }

  void applyFilter(OfferFilterModel value) {
    filter = value;
    notifyListeners();
  }
}
