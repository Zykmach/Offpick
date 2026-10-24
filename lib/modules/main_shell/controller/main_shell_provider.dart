import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view/main_shell_screen.dart';
import 'main_shell_controller.dart';

class MainShellProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(create: (context) => MainShellController());
  }

  static Widget screen() => const MainShellScreen();
}
