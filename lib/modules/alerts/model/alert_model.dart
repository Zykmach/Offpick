import 'alert_trigger.dart';

enum AlertTarget { product, category }

/// A saved alert, either on one product or on a whole category.
class AlertModel {
  final String id;
  final AlertTarget target;
  final String targetId;
  final String title;
  final String detail;
  final String iconKey;
  final String tint;
  final List<AlertTrigger> triggers;
  final bool isActive;

  const AlertModel({
    required this.id,
    required this.target,
    required this.targetId,
    required this.title,
    required this.detail,
    required this.iconKey,
    required this.tint,
    required this.triggers,
    required this.isActive,
  });

  bool get isProduct => target == AlertTarget.product;

  String get subtitle {
    if (!isActive) return 'Paused';
    final kind = isProduct ? 'Product' : 'Category';
    return detail.isEmpty ? kind : '$kind · $detail';
  }

  AlertModel copyWith({bool? isActive, List<AlertTrigger>? triggers}) {
    return AlertModel(
      id: id,
      target: target,
      targetId: targetId,
      title: title,
      detail: detail,
      iconKey: iconKey,
      tint: tint,
      triggers: triggers ?? this.triggers,
      isActive: isActive ?? this.isActive,
    );
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      target: json['target'] == 'product' ? AlertTarget.product : AlertTarget.category,
      targetId: json['targetId'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String? ?? '',
      iconKey: json['icon'] as String,
      tint: json['tint'] as String,
      triggers: (json['triggers'] as List).map((item) => AlertTrigger.fromName(item as String)).toList(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'target': target.name,
        'targetId': targetId,
        'title': title,
        'detail': detail,
        'icon': iconKey,
        'tint': tint,
        'triggers': triggers.map((item) => item.name).toList(),
        'isActive': isActive,
      };
}
