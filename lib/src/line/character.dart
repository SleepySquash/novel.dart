import 'package:novel/novel.dart';

import '/src/core/line.dart';
import '/src/object/character.dart';

class CharacterLine extends AddObjectLine {
  CharacterLine(
    String asset, {
    double position = 0.5,
    bool wait = true,
    int? depth,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(
          CharacterObject(
            asset,
            position: position,
            duration: duration,
          ),
          wait: wait,
          depth: depth ?? Novel.characterDepth,
        );

  @override
  Future<void> execute() => object.init();
}

class HideCharacterLine extends RemoveObjectLine {
  HideCharacterLine(
    String asset, {
    bool wait = true,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(CharacterObject(asset, duration: duration), wait: wait);
}
