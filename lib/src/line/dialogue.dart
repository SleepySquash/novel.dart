import '/src/core/line.dart';
import '/src/object/dialogue.dart';

class DialogueLine extends AddObjectLine {
  DialogueLine(String text, {String? by, bool wait = true})
      : super(Dialogue(text: text, by: by), wait: wait);

  @override
  Future<void> execute() => object.init();
}
