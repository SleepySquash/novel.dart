import '/src/core/line.dart';
import '/src/object/dialogue.dart';

class DialogueLine extends AddObjectLine {
  DialogueLine(String text, {String? by, this.voice, bool wait = true})
      : super(Dialogue(text: text, by: by), wait: wait);

  final String? voice;

  @override
  Future<void> execute() => object.init();
}
