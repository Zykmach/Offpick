import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'circle_icon_button.dart';

/// Opens a rounded bottom sheet that sits above the keyboard.
Future<T?> showAppSheet<T>(BuildContext context, {required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
      child: builder(sheetContext),
    ),
  );
}

/// Handle, title, close button and content. Use inside [showAppSheet].
class SheetLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer;

  const SheetLayout({super.key, required this.title, required this.child, this.footer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Text(title, style: AppTextStyles.heading1)),
                CircleIconButton(
                  icon: LucideIcons.x,
                  size: 44,
                  background: colors.surfaceMuted,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(child: SingleChildScrollView(child: child)),
            if (footer != null) ...[const SizedBox(height: 16), footer!],
          ],
        ),
      ),
    );
  }
}

/// Row with a title and a check mark, used for simple pick lists in sheets.
class SheetOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const SheetOption({super.key, required this.label, required this.selected, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? colors.limeSoft : colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AppColors.lime : colors.border),
        ),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 14)],
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 16))),
            AnimatedOpacity(
              opacity: selected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(LucideIcons.check, color: colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
