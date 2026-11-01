import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../repositories/catalog_repository.dart';
import '../../../repositories/home_repository.dart';
import '../../../routes/route_arguments.dart';
import '../../../services/link_service.dart';
import '../../offers/model/offer_model.dart';
import '../../offers/model/store_model.dart';

/// "Taking you to Myntra" – fills a progress bar, then opens the store.
class RedirectController extends ChangeNotifier {
  final HomeRepository homeRepository;
  final CatalogRepository catalogRepository;
  final LinkService linkService;
  final RedirectArgs args;

  OfferModel? offer;
  StoreModel? store;
  double progress = 0;
  bool isCancelled = false;
  Timer? timer;
  Future<String>? linkFuture;

  RedirectController({
    required this.homeRepository,
    required this.catalogRepository,
    required this.linkService,
    required this.args,
  });

  int? get price => args.price ?? offer?.price;

  int get discountPercent {
    final current = offer;
    final value = price;
    if (current == null) return 0;
    if (value == null || current.mrp == null) return current.discountPercent;
    return ((current.mrp! - value) * 100 / current.mrp!).floor();
  }

  String get storeName => store?.name ?? offer?.storeName ?? 'the store';

  bool get isBestPrice => args.storeId.isNotEmpty;

  /// Loads the store and waits for the progress bar.
  /// Returns true if the store was opened, false if the user stayed.
  Future<bool> start() async {
    offer = await homeRepository.offerById(args.offerId);
    final storeId = args.storeId.isNotEmpty ? args.storeId : offer?.storeId ?? '';
    store = await catalogRepository.storeById(storeId);
    linkFuture = makeLink();
    notifyListeners();

    final done = Completer<void>();
    const step = Duration(milliseconds: 50);
    final increment = step.inMilliseconds / AppConstants.redirectDuration.inMilliseconds;
    timer = Timer.periodic(step, (tick) {
      progress = (progress + increment).clamp(0, 1);
      notifyListeners();
      if (progress >= 1 || isCancelled) {
        tick.cancel();
        if (!done.isCompleted) done.complete();
      }
    });
    await done.future;

    if (isCancelled) return false;
    return openStore();
  }

  Future<bool> openStore() async {
    timer?.cancel();
    if (offer == null) return false;
    progress = 1;
    notifyListeners();
    final link = await (linkFuture ??= makeLink());
    return linkService.openExternal(link);
  }

  /// The offer's own page, or a search on the store picked in Compare,
  /// turned into our Cuelinks link so the purchase earns a commission.
  /// If that fails the user still gets to the store, just without tracking.
  Future<String> makeLink() async {
    final current = offer!;
    final isOfferStore = args.storeId.isEmpty || args.storeId == current.storeId;
    final otherStore = store;
    final plainUrl = !isOfferStore && otherStore != null && otherStore.hasSearch
        ? otherStore.linkFor('${current.brand} ${current.title}')
        : current.url;
    try {
      return await homeRepository.storeLink(url: plainUrl, offerId: current.id);
    } catch (error) {
      debugPrint('Affiliate link failed: $error');
      return plainUrl;
    }
  }

  void cancel() {
    isCancelled = true;
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
