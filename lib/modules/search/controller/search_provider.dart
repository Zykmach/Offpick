import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../view/search_results_screen.dart';
import '../view/search_screen.dart';
import 'search_results_controller.dart';
import 'search_screen_controller.dart';

class SearchProvider {
  static Widget searchScreen() {
    return ChangeNotifierProvider(
      create: (context) => SearchScreenController(
        homeRepository: context.read(),
        preferences: context.read(),
      )..load(),
      child: const SearchScreen(),
    );
  }

  static Widget resultsScreen(String query) {
    return ChangeNotifierProvider(
      create: (context) => SearchResultsController(
        homeRepository: context.read(),
        catalogRepository: context.read(),
        query: query,
      )..load(),
      child: const SearchResultsScreen(),
    );
  }
}
