import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../repositories/subscription_repository.dart';
import '../model/plan_model.dart';

class ProController extends ChangeNotifier {
  final SubscriptionRepository repository;

  bool isPro;
  PlanModel selectedPlan = PlanModel.yearly;
  bool isPurchasing = false;
  bool isRestoring = false;
  String? errorMessage;

  ProController(this.repository) : isPro = repository.isPro;

  String get planLabel => isPro ? 'Pro plan' : 'Free plan';

  void refresh() {
    isPro = repository.isPro;
    notifyListeners();
  }

  void selectPlan(PlanModel plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  Future<bool> purchase() async {
    isPurchasing = true;
    errorMessage = null;
    notifyListeners();
    try {
      isPro = await repository.purchase(selectedPlan);
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isPurchasing = false;
    notifyListeners();
    return isPro;
  }

  Future<bool> restore() async {
    isRestoring = true;
    errorMessage = null;
    notifyListeners();
    try {
      isPro = await repository.restore();
    } catch (error) {
      errorMessage = AppException.from(error).message;
    }
    isRestoring = false;
    notifyListeners();
    return isPro;
  }
}
