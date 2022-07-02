import 'package:get/get.dart';

import 'core/line.dart';
import 'core/object.dart';
import 'core/scenario.dart';
import 'object/backdrop.dart';
import 'object/background.dart';
import 'object/character.dart';
import 'object/dialogue.dart';

class NovelController extends GetxController {
  NovelController(this.scenario, {this.onEnd});

  /// [Scenario] being read in this [NovelController].
  final Scenario scenario;

  /// Currently executed [NovelLine] of the [scenario].
  final RxInt currentLine = RxInt(0);

  /// [NovelObject]s to display in the view.
  final RxList<NovelObject> objects = RxList();

  /// Callback, called when the [Novel] ends reading its [scenario].
  ///
  /// Calls the [Navigator.pop], if `null`.
  final void Function()? onEnd;

  @override
  void onInit() {
    thread();
    super.onInit();
  }

  Future<void> thread() async {
    Line? line;

    do {
      line = scenario.at(currentLine.value);
      currentLine.value = currentLine.value + 1;

      if (line is AddObjectLine) {
        if (line.object is Background) {
          objects.removeWhere((e) => e is Background);
          objects.insert(0, line.object);
        } else if (line.object is BackdropRect) {
          objects.removeWhere((e) => e is BackdropRect);
          objects.insert(0, line.object);
        } else if (line.object is Character) {
          objects.add(line.object);
        } else if (line.object is Dialogue) {
          NovelObject? dialogue =
              objects.firstWhereOrNull((e) => e is Dialogue);
          objects.removeWhere((e) => e is Dialogue);

          line.object.key = dialogue?.key ?? line.object.key;
          objects.add(line.object);
        } else {
          objects.add(line.object);
        }
      } else if (line is RemoveObjectLine) {
        var object = line.object;
        if (object is Background) {
          objects
              .removeWhere((e) => e is Background && e.asset == object.asset);
        } else if (object is BackdropRect) {
          objects.removeWhere((e) => e is BackdropRect);
        } else if (object is Character) {
          objects.removeWhere((e) => e is Character && e.asset == object.asset);
        }
      }

      if (line is Awaitable) {
        if (line.wait) {
          await line.execute();
        }
      }
    } while (line != null);

    onEnd?.call();
  }
}
