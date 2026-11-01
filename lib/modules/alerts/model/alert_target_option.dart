import '../../../core/utils/formatters.dart';
import '../../categories/model/subcategory_model.dart';
import '../../offers/model/offer_model.dart';
import 'alert_model.dart';
import 'alert_trigger.dart';

/// Something an alert can watch, shown as a tab in the "Set an alert" sheet.
class AlertTargetOption {
  final AlertTarget target;
  final String targetId;
  final String title;
  final String detail;
  final String tabLabel;
  final String iconKey;
  final String tint;
  final String previewBody;

  const AlertTargetOption({
    required this.target,
    required this.targetId,
    required this.title,
    required this.detail,
    required this.tabLabel,
    required this.iconKey,
    required this.tint,
    required this.previewBody,
  });

  bool get isProduct => target == AlertTarget.product;

  factory AlertTargetOption.forOffer(OfferModel offer) {
    return AlertTargetOption(
      target: AlertTarget.product,
      targetId: offer.id,
      title: offer.title,
      detail: 'all stores',
      tabLabel: 'This product',
      iconKey: offer.iconKey,
      tint: offer.tint,
      previewBody: offer.hasPrice
          ? '${Formatters.price(offer.mrp!)} → ${Formatters.price(offer.price!)} · '
              '${offer.discountPercent}% OFF on ${offer.storeName}. Offer ending soon.'
          : '${offer.dealLabel} on ${offer.storeName}. Offer ending soon.',
    );
  }

  factory AlertTargetOption.forSubcategory(SubcategoryModel subcategory, String categoryName) {
    return AlertTargetOption(
      target: AlertTarget.category,
      targetId: subcategory.id,
      title: subcategory.groupId.isEmpty ? subcategory.pathName(categoryName) : subcategory.fullName,
      detail: '',
      tabLabel: 'All ${subcategory.fullName}',
      iconKey: 'grid',
      tint: subcategory.tint,
      previewBody: 'New deals just dropped in ${subcategory.fullName}. Tap to see them.',
    );
  }

  /// A whole category or one side of it, e.g. "Men's fashion".
  factory AlertTargetOption.forCategory({
    required String categoryId,
    required String groupId,
    required String name,
    required String iconKey,
    required String tint,
  }) {
    return AlertTargetOption(
      target: AlertTarget.category,
      targetId: groupId.isEmpty ? categoryId : '$categoryId:$groupId',
      title: name,
      detail: '',
      tabLabel: 'All $name',
      iconKey: iconKey,
      tint: tint,
      previewBody: 'New offers are live in $name. Tap to see them.',
    );
  }

  /// Used when editing an alert that already exists.
  factory AlertTargetOption.fromAlert(AlertModel alert) {
    return AlertTargetOption(
      target: alert.target,
      targetId: alert.targetId,
      title: alert.title,
      detail: alert.detail,
      tabLabel: alert.title,
      iconKey: alert.iconKey,
      tint: alert.tint,
      previewBody: 'Something you are watching in ${alert.title} just changed.',
    );
  }

  AlertModel toAlert(List<AlertTrigger> triggers) {
    return AlertModel(
      id: 'alert-${DateTime.now().millisecondsSinceEpoch}',
      target: target,
      targetId: targetId,
      title: title,
      detail: detail,
      iconKey: iconKey,
      tint: tint,
      triggers: triggers,
      isActive: true,
    );
  }
}
