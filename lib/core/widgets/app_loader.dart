import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Centered spinner used while a screen is loading.
class AppLoader extends StatelessWidget {
  final double size;

  const AppLoader({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(strokeWidth: 3, color: context.colors.accent),
      ),
    );
  }
}

/// Grey rounded block that gently pulses, used as a loading placeholder.
class SkeletonBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const SkeletonBox({super.key, required this.height, this.width, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: context.colors.surfaceMuted,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
