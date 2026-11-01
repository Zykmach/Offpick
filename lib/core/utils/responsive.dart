import 'package:flutter/widgets.dart';

/// Keeps text readable and layouts intact on every phone size.
/// The design is made for a 390pt wide phone: text gets a little smaller on
/// small phones and a little bigger on large ones. The phone's own text size
/// setting is still respected, up to 1.3x, so screens never break.
class Responsive {
  static const double designWidth = 390;

  static TextScaler textScalerFor(MediaQueryData media) {
    final widthScale = (media.size.width / designWidth).clamp(0.85, 1.1);
    final userScale = media.textScaler.scale(1).clamp(0.85, 1.3);
    return TextScaler.linear(widthScale * userScale);
  }

  /// Grid tiles hold text and icons, so they get taller when the user picks
  /// larger text, and on phones narrower than the design (icons do not shrink).
  /// [designRatio] is the width / height that looks right on the design phone.
  static double tileRatio(BuildContext context, double designRatio) {
    final media = MediaQuery.of(context);
    final widthScale = (media.size.width / designWidth).clamp(0.85, 1.1);
    final userScale = media.textScaler.scale(1) / widthScale;
    return designRatio * widthScale.clamp(0.85, 1.0) / userScale.clamp(1.0, 1.3);
  }

  /// Wraps the whole app, see OffpickApp.
  static Widget wrap(BuildContext context, Widget? child) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: textScalerFor(media)),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
