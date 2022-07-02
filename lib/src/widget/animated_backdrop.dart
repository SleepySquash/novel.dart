import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBackdropFilter extends StatefulWidget {
  const AnimatedBackdropFilter({
    Key? key,
    this.sigma = 15,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linear,
    this.onEnd,
  }) : super(key: key);

  final int sigma;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final void Function()? onEnd;

  @override
  State<AnimatedBackdropFilter> createState() => _AnimatedBackdropFilterState();
}

class _AnimatedBackdropFilterState extends State<AnimatedBackdropFilter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
        case AnimationStatus.dismissed:
          // No-op.
          break;

        case AnimationStatus.completed:
          widget.onEnd?.call();
          break;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(curve: widget.curve, parent: _controller),
      builder: (context, child) {
        return BackdropFilter(
          blendMode: BlendMode.src,
          filter: ImageFilter.blur(
            sigmaX: widget.sigma * _controller.value + 0.001,
            sigmaY: widget.sigma * _controller.value + 0.001,
          ),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
