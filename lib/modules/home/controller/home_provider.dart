import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'home_controller.dart';

class HomeProvider {
  static SingleChildWidget global() {
    return ChangeNotifierProvider(
      create: (context) => HomeController(
        homeRepository: context.read(),
        catalogRepository: context.read(),
        preferences: context.read(),
      ),
    );
  }
}
