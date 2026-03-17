import 'package:flutter/material.dart';

class FadeOpacity extends StatelessWidget {
  final bool visible;
  final Duration duration;
  final Widget child;

  const FadeOpacity({
    super.key,
    required this.visible,
    this.duration = const Duration(milliseconds: 500),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: duration,
      child: child,
    );
  }
}
