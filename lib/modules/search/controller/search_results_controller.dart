import 'package:flutter/material.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/catalog_repository.dart';
import '../../../repositories/home_repository.dart';
import '../../categories/model/category_model.dart';
import '../../categories/model/subcategory_model.dart';
import '../../offers/model/offer_filter_model.dart';
import '../../offers/model/offer_model.dart';
import '../../offers/model/store_model.dart';

class SearchResultsController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final CatalogRepository catalogRepository;
  final TextEditingController textController;

  String query;
  List<OfferModel> results = [];
  List<SubcategoryModel> foundIn = [];
  List<CategoryModel> categories = [];
  List<StoreModel> stores = [];
  String? selectedSubcategoryId;
  OfferFilterModel filter = const OfferFilterModel();
  bool isLoading = true;
  String? errorMessage;

  SearchResultsController({required this.homeRepository, required this.catalogRepository, required this.query})
      : textController = TextEditingController(text: query);

  /// Results after the "In:" chip, quick chips and filter sheet are applied.
  List<OfferModel> get visibleResults {
    final now = DateTime.now();
    final inSubcategory = results.where((offer) {
      final matchesChip = selectedSubcategoryId == null || offer.subcategoryId == selectedSubcategoryId;
      return matchesChip && offer.isLiveAt(now);
    }).toList();
    return filter.apply(inSubcategory);
  }

  bool get onlyBigDiscounts => filter.minDiscount >= 30;

  String pathFor(SubcategoryModel subcategory) {
    final category = categories.where((item) => item.id == subcategory.categoryId);
    return subcategory.pathName(category.isEmpty ? '' : category.first.name);
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      categories = await catalogRepository.fetchCategories();
      stores = await catalogRepository.fetchStores();
      results = await homeRepository.search(query);

      final subcategoryIds = results.map((offer) => offer.subcategoryId).toSet();
      foundIn = [
        for (final category in categories)
          ...category.subcategories.where((item) => subcategoryIds.contains(item.id)),
      ];
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> search(String value) async {
    final text = value.trim();
    if (text.isEmpty || text == query) return;
    query = text;
    selectedSubcategoryId = null;
    await load();
  }

  void selectSubcategory(String id) {
    selectedSubcategoryId = selectedSubcategoryId == id ? null : id;
    notifyListeners();
  }

  void setSort(OfferSort sort) {
    filter = filter.copyWith(sort: sort);
    notifyListeners();
  }

  void toggleBigDiscounts() {
    filter = filter.copyWith(minDiscount: onlyBigDiscounts ? 0 : 30);
    notifyListeners();
  }

  void applyFilter(OfferFilterModel value) {
    filter = value;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
