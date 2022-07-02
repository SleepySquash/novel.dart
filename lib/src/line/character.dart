import '/src/core/line.dart';
import '/src/object/character.dart';

class CharacterLine extends AddObjectLine {
  CharacterLine(
    String asset, {
    bool wait = true,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(Character(asset, duration: duration), wait: wait);

  @override
  Future<void> execute() => object.init();
}

class HideCharacterLine extends RemoveObjectLine {
  HideCharacterLine(
    String asset, {
    bool wait = true,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(Character(asset, duration: duration), wait: wait);
}
