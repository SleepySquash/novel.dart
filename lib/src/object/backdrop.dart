import 'package:flutter/widgets.dart';

import '/src/core/object.dart';
import '/src/widget/animated_backdrop.dart';

class BackdropRect extends NovelObject with GuardedMixin {
  BackdropRect({this.duration = const Duration(milliseconds: 300)});

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackdropFilter(
      duration: duration,
      onEnd: unlock,
      child: Container(),
    );
  }
}
