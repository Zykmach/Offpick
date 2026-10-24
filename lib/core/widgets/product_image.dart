import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_icon.dart';

/// Tinted box with a product icon. Stands in for the product photo.
/// When real photos arrive, put an Image inside the same tinted box.
class ProductImage extends StatelessWidget {
  final String iconKey;
  final String tint;
  final double? width;
  final double? height;
  final double radius;
  final double iconSize;
  final String? heroTag;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.iconKey,
    required this.tint,
    this.width,
    this.height,
    this.radius = 18,
    this.iconSize = 40,
    this.heroTag,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.tint(tint),
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: AppIcon(iconKey, size: iconSize, color: colors.placeholderIcon),
    );

    if (heroTag == null) return box;
    return Hero(
      tag: heroTag!,
      child: Material(type: MaterialType.transparency, child: box),
    );
  }
}

/// Square letter badge used instead of store logos (M, Aj, F, A).
class StoreAvatar extends StatelessWidget {
  final String monogram;
  final double size;
  final bool highlighted;
  final bool circle;

  const StoreAvatar({
    super.key,
    required this.monogram,
    this.size = 48,
    this.highlighted = false,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlighted ? AppColors.lime : colors.surfaceMuted,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.3),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Text(
        monogram,
        style: TextStyle(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          color: highlighted ? AppColors.onLime : colors.textPrimary,
        ),
      ),
    );
  }
}
