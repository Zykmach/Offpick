import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Three dots that pulse one after another, like "• • •" while loading.
/// The AnimationController drives AnimatedBuilder, so no setState is needed.
class LoadingDots extends StatefulWidget {
  final double size;

  const LoadingDots({super.key, this.size = 10});

  @override
  State<LoadingDots> createState() => LoadingDotsState();
}

class LoadingDotsState extends State<LoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final wave = math.sin((controller.value - index * 0.18) * 2 * math.pi);
            final strength = (wave + 1) / 2;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: AppColors.lime.withValues(alpha: 0.35 + strength * 0.65),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
