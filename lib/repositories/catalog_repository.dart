import '../core/constants/db_tables.dart';
import '../modules/categories/model/category_model.dart';
import '../modules/categories/model/subcategory_model.dart';
import '../modules/interests/model/interest_model.dart';
import '../modules/offers/model/offer_model.dart';
import '../modules/offers/model/store_model.dart';
import '../services/supabase_service.dart';
import 'home_repository.dart';

/// Categories, stores and interests. These rarely change so they are cached.
class CatalogRepository {
  final SupabaseService supabase;
  final HomeRepository homeRepository;
  List<CategoryModel>? cachedCategories;
  List<StoreModel>? cachedStores;
  List<InterestModel>? cachedInterests;

  CatalogRepository({required this.supabase, required this.homeRepository});

  /// Categories with how many live offers each one has right now.
  Future<List<CategoryModel>> fetchCategories() async {
    if (cachedCategories != null) return cachedCategories!;
    final rows = await supabase.readAll(DbTables.categoryFeed, orderBy: 'sort_order');
    final offers = await liveOffers();
    cachedCategories = rows.map((row) => CategoryModel.fromJson(withOfferCounts(row, offers))).toList();
    return cachedCategories!;
  }

  /// The catalog still opens if the offers cannot be loaded, just with zero counts.
  Future<List<OfferModel>> liveOffers() async {
    try {
      return await homeRepository.fetchOffers();
    } catch (error) {
      return [];
    }
  }

  Map<String, dynamic> withOfferCounts(Map<String, dynamic> row, List<OfferModel> offers) {
    final subcategories = (row['subcategories'] as List).cast<Map<String, dynamic>>();
    return {
      ...row,
      'liveOffers': offers.where((offer) => offer.categoryId == row['id']).length,
      'subcategories': subcategories
          .map((item) => {
                ...item,
                'offerCount': offers.where((offer) => offer.subcategoryId == item['id']).length,
              })
          .toList(),
    };
  }

  Future<List<StoreModel>> fetchStores() async {
    if (cachedStores != null) return cachedStores!;
    final rows = await supabase.readAll(DbTables.storeFeed, orderBy: 'sort_order');
    cachedStores = rows.map(StoreModel.fromJson).toList();
    return cachedStores!;
  }

  Future<List<InterestModel>> fetchInterests() async {
    if (cachedInterests != null) return cachedInterests!;
    final rows = await supabase.readAll(DbTables.interestFeed, orderBy: 'sort_order');
    cachedInterests = rows.map(InterestModel.fromJson).toList();
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

  /// Stores in the table first. Any other Cuelinks brand is built from its offers.
  Future<StoreModel?> storeById(String id) async {
    final stores = await fetchStores();
    for (final store in stores) {
      if (store.id == id) return store;
    }
    for (final offer in await liveOffers()) {
      if (offer.storeId == id) {
        return StoreModel(id: id, name: offer.storeName, monogram: offer.storeName[0], searchUrl: '', featured: false);
      }
    }
    return null;
  }
}
