import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view/paywall_screen.dart';
import 'pro_controller.dart';

class ProProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(create: (context) => ProController(context.read()));
  }

  static Widget paywallScreen() => const PaywallScreen();
}
