import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../repositories/home_repository.dart';
import '../../../repositories/preferences_repository.dart';
import '../../offers/model/offer_model.dart';
import '../model/trending_model.dart';

/// The search page before results: recent, trending and live suggestions.
class SearchScreenController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final PreferencesRepository preferences;
  final TextEditingController textController = TextEditingController();

  List<String> recent = [];
  List<TrendingModel> trending = [];
  List<OfferModel> suggestions = [];

  SearchScreenController({required this.homeRepository, required this.preferences}) {
    recent = preferences.recentSearches;
  }

  String get query => textController.text.trim();

  bool get isTyping => query.isNotEmpty;

  Future<void> load() async {
    try {
      trending = await homeRepository.fetchTrending();
    } catch (error) {
      trending = [];
    }
    notifyListeners();
  }

  Future<void> onQueryChanged(String value) async {
    final text = value.trim();
    if (text.isEmpty) {
      suggestions = [];
      notifyListeners();
      return;
    }
    final matches = await homeRepository.search(text);
    // Ignore results for a query the user has already changed.
    if (text != query) return;
    suggestions = matches.take(6).toList();
    notifyListeners();
  }

  /// Saves the search to "Recent" and returns the cleaned query.
  Future<String?> submit(String value) async {
    final text = value.trim();
    if (text.isEmpty) return null;
    recent = [text, ...recent.where((item) => item.toLowerCase() != text.toLowerCase())]
        .take(AppConstants.maxRecentSearches)
        .toList();
    notifyListeners();
    await preferences.saveRecentSearches(recent);
    return text;
  }

  Future<void> clearRecent() async {
    recent = [];
    notifyListeners();
    await preferences.saveRecentSearches(recent);
  }

  void clearText() {
    textController.clear();
    suggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
