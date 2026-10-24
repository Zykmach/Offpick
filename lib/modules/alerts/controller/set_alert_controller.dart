import 'package:flutter/foundation.dart';

import '../model/alert_model.dart';
import '../model/alert_target_option.dart';
import '../model/alert_trigger.dart';
import 'alerts_controller.dart';

/// State of the "Set an alert" bottom sheet.
class SetAlertController extends ChangeNotifier {
  final AlertsController alertsController;
  final List<AlertTargetOption> options;

  int optionIndex = 0;
  Set<AlertTrigger> selected = {};
  bool isSaving = false;

  SetAlertController({required this.alertsController, required this.options}) {
    loadSelection();
  }

  AlertTargetOption get option => options[optionIndex];

  bool get isEditing => alertsController.alertFor(option.targetId) != null;

  bool get canSave => selected.isNotEmpty && !isSaving;

  /// Start with the alert's saved triggers, or a sensible default.
  void loadSelection() {
    final existing = alertsController.alertFor(option.targetId);
    if (existing != null) {
      selected = existing.triggers.toSet();
    } else {
      selected = {option.isProduct ? AlertTrigger.priceDrop : AlertTrigger.newOffer};
    }
  }

  void selectOption(int index) {
    if (optionIndex == index) return;
    optionIndex = index;
    loadSelection();
    notifyListeners();
  }

  void toggle(AlertTrigger trigger) {
    selected = {...selected};
    if (!selected.remove(trigger)) selected.add(trigger);
    notifyListeners();
  }

  Future<AlertModel> save() async {
    isSaving = true;
    notifyListeners();
    // Keep the triggers in the order they are listed in the sheet.
    final triggers = AlertTrigger.values.where(selected.contains).toList();
    final alert = await alertsController.saveAlert(option.toAlert(triggers), previewBody: option.previewBody);
    isSaving = false;
    notifyListeners();
    return alert;
  }
}
