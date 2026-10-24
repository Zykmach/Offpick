import 'dart:async';

import 'package:flutter/foundation.dart';

/// Ticks once a second so every countdown in the app stays in sync
/// with a single timer instead of one timer per card.
class ClockService extends ChangeNotifier {
  DateTime now = DateTime.now();
  Timer? timer;

  ClockService() {
    timer = Timer.periodic(const Duration(seconds: 1), (tick) {
      now = DateTime.now();
      notifyListeners();
    });
  }

  Duration remainingUntil(DateTime endsAt) => endsAt.difference(now);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
