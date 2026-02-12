import 'package:flutter/material.dart';

/// Custom page transition for pin detail — slides up from bottom
/// with a fade, matching Pinterest's detail screen entrance.
class PinDetailPageRoute<T> extends PageRouteBuilder<T> {
  PinDetailPageRoute({required this.child})
    : super(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
      );

  final Widget child;
}
