import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../routes/route_arguments.dart';
import '../view/category_detail_screen.dart';
import 'categories_controller.dart';
import 'category_detail_controller.dart';

class CategoriesProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(create: (context) => CategoriesController(context.read()));
  }

  static Widget detailScreen(CategoryArgs args) {
    return ChangeNotifierProvider(
      create: (context) => CategoryDetailController(
        repository: context.read(),
        categoryId: args.categoryId,
        initialGroup: args.groupId,
      ),
      child: const CategoryDetailScreen(),
    );
  }
}
