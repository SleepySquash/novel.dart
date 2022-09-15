import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'core/line.dart';
import 'core/object.dart';
import 'core/scenario.dart';
import 'line/background.dart';
import 'line/character.dart';
import 'line/dialogue.dart';
import 'line/music.dart';
import 'line/wait.dart';
import 'object/backdrop.dart';
import 'object/background.dart';
import 'object/character.dart';
import 'object/dialogue.dart';
import 'util/log.dart';
import 'view.dart';

class NovelController extends GetxController {
  NovelController(this.scenario, {this.onEnd});

  /// [Scenario] being read in this [NovelController].
  final Scenario scenario;

  /// Currently executed [NovelLine] of the [scenario].
  final RxInt currentLine = RxInt(0);

  /// [NovelObject]s to display in the view.
  final RxList<NovelObject> objects = RxList();

  /// [AudioPlayer] playing the voice lines.
  final AudioPlayer voice = AudioPlayer();

  /// [AudioPlayer] playing the ambient music.
  final AudioPlayer ambient = AudioPlayer();

  /// Callback, called when the [Novel] ends reading its [scenario].
  ///
  /// Calls the [Navigator.pop], if `null`.
  final void Function()? onEnd;

  @override
  void onInit() {
    ambient.setLoopMode(LoopMode.one);

    thread();
    super.onInit();
  }

  @override
  void dispose() {
    print('NOVEL DISPOSE!!!');
    super.dispose();
  }

  @override
  void onClose() {
    ambient.dispose();
    voice.dispose();
    super.onClose();
  }

  Future<void> thread() async {
    Log.print('Thread 0 started');
    Line? line;

    do {
      line = scenario.at(currentLine.value);
      currentLine.value = currentLine.value + 1;

      if (line is AddObjectLine) {
        Log.print('Adding ${line.object} to the scene');

        if (line is BackgroundLine) {
          objects.removeWhere((e) => e is Background);
          objects.insert(0, line.object);
        } else if (line.object is BackdropRect) {
          objects.removeWhere((e) => e is BackdropRect);
          objects.insert(0, line.object);
        } else if (line is CharacterLine) {
          objects.add(line.object);
        } else if (line is DialogueLine) {
          NovelObject? previous =
              objects.firstWhereOrNull((e) => e is Dialogue);
          objects.removeWhere((e) => e is Dialogue);

          if (line.voice != null) {
            voice
                .setAsset('assets/${Novel.voices}/${line.voice}')
                .then((_) => voice.play());
            ;
          }

          line.object.key = previous?.key ?? line.object.key;
          objects.add(line.object);
        } else {
          objects.add(line.object);
        }
      } else if (line is RemoveObjectLine) {
        Log.print('Removing ${line.object} from the scene');

        NovelObject object = line.object;
        if (object is Background) {
          objects
              .removeWhere((e) => e is Background && e.asset == object.asset);
        } else if (object is BackdropRect) {
          objects.removeWhere((e) => e is BackdropRect);
        } else if (object is Character) {
          objects.removeWhere((e) => e is Character && e.asset == object.asset);
        }
      } else if (line is WaitLine) {
        Log.print('Waiting for ${line.duration}');
      } else if (line is MusicLine) {
        Log.print('Playing ${line.asset}');
        ambient
            .setAsset('assets/${Novel.musics}/${line.asset}')
            .then((_) => ambient.play());
      } else if (line is StopMusicLine) {
        Log.print('Stopping any music being played');
        ambient.stop();
      }

      if (line is Awaitable) {
        voice.stop();
        if (line.wait) {
          await line.execute();
        }
      }
    } while (line != null);

    onEnd?.call();
    Log.print('Thread 0 ended');
  }
}
