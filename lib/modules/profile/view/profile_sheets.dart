import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controller/edit_profile_controller.dart';
import '../controller/theme_controller.dart';

void showEditProfileSheet(BuildContext context) {
  showAppSheet<void>(
    context,
    builder: (sheetContext) => ChangeNotifierProvider(
      create: (context) => EditProfileController(context.read()),
      child: Consumer<EditProfileController>(
        builder: (context, controller, child) => SheetLayout(
          title: 'Edit profile',
          footer: AppButton(
            label: 'Save',
            isLoading: controller.isSaving,
            onPressed: () async {
              final saved = await controller.save();
              if (saved && context.mounted) Navigator.of(context).pop();
            },
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: AppTextField(
              controller: controller.nameController,
              autofocus: true,
              hint: 'Your name',
              prefixIcon: LucideIcons.user,
              errorText: controller.nameError,
              onChanged: (value) => controller.clearError(),
            ),
          ),
        ),
      ),
    ),
  );
}

void showAppearanceSheet(BuildContext context) {
  showAppSheet<void>(
    context,
    builder: (sheetContext) => Consumer<ThemeController>(
      builder: (context, controller, child) => SheetLayout(
        title: 'Appearance',
        child: Column(
          children: [
            SheetOption(
              label: 'System',
              icon: LucideIcons.monitor,
              selected: controller.themeMode == ThemeMode.system,
              onTap: () => controller.setThemeMode(ThemeMode.system),
            ),
            SheetOption(
              label: 'Light',
              icon: LucideIcons.sun,
              selected: controller.themeMode == ThemeMode.light,
              onTap: () => controller.setThemeMode(ThemeMode.light),
            ),
            SheetOption(
              label: 'Dark',
              icon: LucideIcons.moon,
              selected: controller.themeMode == ThemeMode.dark,
              onTap: () => controller.setThemeMode(ThemeMode.dark),
            ),
          ],
        ),
      ),
    ),
  );
}
