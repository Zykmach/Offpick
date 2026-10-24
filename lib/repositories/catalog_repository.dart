import '../core/network/api_endpoints.dart';
import '../modules/categories/model/category_model.dart';
import '../modules/categories/model/subcategory_model.dart';
import '../modules/interests/model/interest_model.dart';
import '../modules/offers/model/store_model.dart';
import '../services/api_service.dart';

/// Categories, stores and interests. These rarely change so they are cached.
class CatalogRepository {
  final ApiService apiService;
  List<CategoryModel>? cachedCategories;
  List<StoreModel>? cachedStores;
  List<InterestModel>? cachedInterests;

  CatalogRepository(this.apiService);

  Future<List<CategoryModel>> fetchCategories() async {
    if (cachedCategories != null) return cachedCategories!;
    final json = await apiService.getList(ApiEndpoints.categories);
    cachedCategories = json.map(CategoryModel.fromJson).toList();
    return cachedCategories!;
  }

  Future<List<StoreModel>> fetchStores() async {
    if (cachedStores != null) return cachedStores!;
    final json = await apiService.getList(ApiEndpoints.stores);
    cachedStores = json.map(StoreModel.fromJson).toList();
    return cachedStores!;
  }

  Future<List<InterestModel>> fetchInterests() async {
    if (cachedInterests != null) return cachedInterests!;
    final json = await apiService.getList(ApiEndpoints.interests);
    cachedInterests = json.map(InterestModel.fromJson).toList();
    return cachedInterests!;
  }

  Future<CategoryModel?> categoryById(String id) async {
    final categories = await fetchCategories();
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  Future<SubcategoryModel?> subcategoryById(String id) async {
    final categories = await fetchCategories();
    for (final category in categories) {
      for (final subcategory in category.subcategories) {
        if (subcategory.id == id) return subcategory;
      }
    }
    return null;
  }

  Future<StoreModel?> storeById(String id) async {
    final stores = await fetchStores();
    for (final store in stores) {
      if (store.id == id) return store;
    }
    return null;
  }
}
