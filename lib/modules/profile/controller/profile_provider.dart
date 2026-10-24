import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'profile_controller.dart';
import 'theme_controller.dart';

class ProfileProvider {
  static List<SingleChildWidget> global() {
    return [
      ChangeNotifierProvider(create: (context) => ThemeController(context.read())),
      ChangeNotifierProvider(
        create: (context) => ProfileController(
          preferences: context.read(),
          notificationService: context.read(),
          linkService: context.read(),
        ),
      ),
    ];
  }
}
