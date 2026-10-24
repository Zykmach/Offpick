import 'package:flutter/material.dart';

enum TransitionType { slide, fade, slideUp }

/// Page route with a soft slide + fade used for every screen in the app.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final TransitionType type;

  AppPageRoute({required this.page, required RouteSettings settings, this.type = TransitionType.slide})
      : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            if (type == TransitionType.fade) {
              return FadeTransition(opacity: curved, child: child);
            }

            if (type == TransitionType.slideUp) {
              return SlideTransition(
                position: Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(curved),
                child: FadeTransition(opacity: curved, child: child),
              );
            }

            // The page underneath slides a little to the left when covered.
            final pushedAway = Tween(begin: Offset.zero, end: const Offset(-0.08, 0)).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic),
            );
            return SlideTransition(
              position: pushedAway,
              child: SlideTransition(
                position: Tween(begin: const Offset(0.18, 0), end: Offset.zero).animate(curved),
                child: FadeTransition(opacity: curved, child: child),
              ),
            );
          },
        );
}
