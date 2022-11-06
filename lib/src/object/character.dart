import 'package:flutter/widgets.dart';

import '/novel.dart';
import '/src/widget/delayed_opacity.dart';

/// Character as a [NovelObject].
class CharacterObject extends NovelObject with GuardedMixin {
  CharacterObject(
    this.asset, {
    this.position = 0.5,
    this.duration = const Duration(milliseconds: 500),
  });

  final double position;
  final String asset;

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      key: key,
      alignment: Alignment(position, 1),
      child: AnimatedDelayedOpacity(
        duration: duration,
        onEnd: unlock,
        child: SizedBox(
          height: double.infinity,
          child: Image(
            image: AssetImage('${Novel.characters}/$asset'),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
    ;
  }
}
