import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../view/interests_screen.dart';
import 'interests_controller.dart';

class InterestsProvider {
  static Widget screen({required bool isEditing}) {
    return ChangeNotifierProvider(
      create: (context) => InterestsController(
        catalogRepository: context.read(),
        preferences: context.read(),
        isEditing: isEditing,
      )..load(),
      child: const InterestsScreen(),
    );
  }
}
