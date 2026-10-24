import '../../offers/model/offer_model.dart';

/// A shopping interest picked during onboarding, e.g. "Men's fashion".
class InterestModel {
  final String id;
  final String label;
  final String iconKey;

  /// Category, subcategory or group ids this interest covers.
  final List<String> matchKeys;

  const InterestModel({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.matchKeys,
  });

  bool matches(OfferModel offer) {
    final groupKey = offer.groupId.isEmpty ? '' : '${offer.categoryId}:${offer.groupId}';
    return matchKeys.contains(offer.categoryId) ||
        matchKeys.contains(offer.subcategoryId) ||
        matchKeys.contains(groupKey);
  }

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] as String,
      label: json['label'] as String,
      iconKey: json['icon'] as String,
      matchKeys: (json['matchKeys'] as List).cast<String>(),
    );
  }
}
