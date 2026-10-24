import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/catalog_repository.dart';
import '../model/category_model.dart';

class CategoriesController extends ChangeNotifier {
  final CatalogRepository repository;

  List<CategoryModel> categories = [];
  bool isLoading = false;
  String? errorMessage;

  CategoriesController(this.repository);

  Future<void> load() async {
    if (categories.isNotEmpty) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      categories = await repository.fetchCategories();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isLoading = false;
    notifyListeners();
  }
}
