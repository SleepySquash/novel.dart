import 'package:flutter/widgets.dart';

import '/novel.dart';
import '/src/widget/delayed_opacity.dart';

/// Background as a [NovelObject].
class BackgroundObject extends NovelObject with GuardedMixin {
  BackgroundObject(
    this.asset, {
    this.duration = const Duration(milliseconds: 500),
  });

  final String asset;

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      key: key,
      child: AnimatedDelayedOpacity(
        duration: duration,
        onEnd: unlock,
        child: Image(
          image: AssetImage('${Novel.backgrounds}/$asset'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
