import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../services/link_service.dart';
import '../../../repositories/catalog_repository.dart';
import '../../../repositories/home_repository.dart';
import '../../categories/model/category_model.dart';
import '../../categories/model/subcategory_model.dart';
import '../../compare/model/comparison_model.dart';
import '../../compare/model/store_price_model.dart';
import '../model/offer_model.dart';

class ProductDetailsController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final CatalogRepository catalogRepository;
  final LinkService linkService;
  final String offerId;

  OfferModel? offer;
  ComparisonModel? comparison;
  SubcategoryModel? subcategory;
  CategoryModel? category;
  int imagePage = 0;
  bool isLoading = true;
  String? errorMessage;

  static const int imageCount = 3;

  ProductDetailsController({
    required this.homeRepository,
    required this.catalogRepository,
    required this.linkService,
    required this.offerId,
  });

  /// Other stores selling the same product, for "Also on 3 more stores".
  List<StorePriceModel> get otherStores {
    final current = offer;
    if (comparison == null || current == null) return [];
    return comparison!.prices.where((item) => item.storeId != current.storeId).toList();
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      offer = await homeRepository.offerById(offerId);
      if (offer == null) throw const AppException('This offer is no longer available.');
      subcategory = await catalogRepository.subcategoryById(offer!.subcategoryId);
      category = await catalogRepository.categoryById(offer!.categoryId);
      isLoading = false;
      notifyListeners();
      comparison = await homeRepository.fetchComparison(offerId);
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> share() async {
    final current = offer;
    if (current == null) return;
    await linkService.share(
      '${current.brand} ${current.title} is ${Formatters.price(current.price)} '
      '(${current.discountPercent}% off) on ${current.storeName}. Found on Offpick.',
    );
  }

  void setImagePage(int index) {
    imagePage = index;
    notifyListeners();
  }
}
