import '../modules/alerts/model/alert_model.dart';

/// Typed arguments passed between screens.

class CategoryArgs {
  final String categoryId;
  final String groupId;

  const CategoryArgs({required this.categoryId, this.groupId = ''});
}

class OfferListArgs {
  final String? subcategoryId;
  final String? categoryId;
  final String groupId;
  final String? title;

  const OfferListArgs({this.subcategoryId, this.categoryId, this.groupId = '', this.title});
}

class RedirectArgs {
  final String offerId;

  /// Store to open. Empty means the store the offer was found on.
  final String storeId;
  final int? price;

  const RedirectArgs({required this.offerId, this.storeId = '', this.price});
}

class AlertCreatedArgs {
  final AlertModel alert;
  final String previewBody;

  const AlertCreatedArgs({required this.alert, required this.previewBody});
}
