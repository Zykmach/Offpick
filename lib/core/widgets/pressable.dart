import 'package:flutter/material.dart';

/// Wraps any widget and gives it a small "press down" scale animation.
/// Uses a ValueNotifier instead of setState to rebuild only the scale.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressedScale;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = 0.96,
  });

  @override
  State<Pressable> createState() => PressableState();
}

class PressableState extends State<Pressable> {
  final ValueNotifier<bool> isPressed = ValueNotifier(false);

  @override
  void dispose() {
    isPressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null && widget.onLongPress == null) return widget.child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => isPressed.value = true,
      onTapUp: (details) => isPressed.value = false,
      onTapCancel: () => isPressed.value = false,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ValueListenableBuilder<bool>(
        valueListenable: isPressed,
        child: widget.child,
        builder: (context, pressed, child) {
          return AnimatedScale(
            scale: pressed ? widget.pressedScale : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: child,
          );
        },
      ),
    );
  }
}
