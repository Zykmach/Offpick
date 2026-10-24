import 'package:flutter/material.dart';

/// Fades and slides a widget up the first time it is built.
/// Give list items an increasing [index] for a staggered effect.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;
  final double offsetY;
  final double offsetX;
  final Duration duration;
  final Duration delayStep;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offsetY = 24,
    this.offsetX = 0,
    this.duration = const Duration(milliseconds: 450),
    this.delayStep = const Duration(milliseconds: 60),
  });

  @override
  Widget build(BuildContext context) {
    final delay = delayStep * index.clamp(0, 8);
    final total = duration + delay;
    final start = delay.inMilliseconds / total.inMilliseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * offsetX, (1 - value) * offsetY),
            child: child,
          ),
        );
      },
    );
  }
}

/// Grows a widget from a smaller size with a soft bounce.
class PopIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double from;

  const PopIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.from = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: from, end: 1),
      duration: duration,
      curve: Curves.elasticOut,
      child: child,
      builder: (context, value, child) => Transform.scale(scale: value, child: child),
    );
  }
}
