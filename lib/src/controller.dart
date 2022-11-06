import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

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
import 'util/rxsplay.dart';
import 'view.dart';

class NovelController extends GetxController {
  NovelController(this.scenario, {this.onEnd});

  /// [Scenario] being read.
  final Scenario scenario;

  /// Index of the currently executed [NovelLine] in the [scenario].
  final RxInt currentLine = RxInt(0);

  final ObjectComposition layers = ObjectComposition();
  final List<Future<dynamic>> holds = [];

  /// [AudioPlayer] playing the voice lines.
  final AudioPlayer voice = AudioPlayer(playerId: 'voice');

  /// [AudioPlayer] playing the ambient music.
  final AudioPlayer ambient = AudioPlayer(playerId: 'ambient');

  /// Callback, called when the [Novel] ends reading its [scenario].
  ///
  /// Calls the [Navigator.pop], if `null`.
  final void Function()? onEnd;

  /// Currently played [AssetSource] of the [voice] player.
  AssetSource? _voiceSource;

  @override
  void onInit() {
    thread();
    super.onInit();
  }

  @override
  void dispose() {
    Log.print('Disposing');
    super.dispose();
  }

  @override
  void onClose() {
    ambient.stop();
    ambient.release();
    voice.stop();
    voice.release();
    super.onClose();
  }

  Future<void> thread() async {
    Log.print('Thread 0 started');
    Line? line;

    do {
      line = scenario.at(currentLine.value);
      currentLine.value = currentLine.value + 1;

      AssetSource? previousVoiceSource = _voiceSource;

      if (line is AddObjectLine) {
        Log.print('Adding ${line.object} to the scene');

        if (line is BackgroundLine) {
          layers.removeOf<BackgroundObject>();
          layers.add(line.object, 0);
        } else if (line.object is BackdropRect) {
          layers.removeOf<BackdropRect>();
          layers.add(line.object, 0);
        } else if (line is CharacterLine) {
          layers.add(line.object, 16000);
        } else if (line is DialogueLine) {
          if (line.voice != null) {
            _voiceSource = AssetSource('${Novel.voices}/${line.voice}');
            voice.play(_voiceSource!);
          }

          layers.removeOf<Dialogue>();
          layers.add(line.object, 32000);
        } else {
          layers.add(line.object);
        }
      } else if (line is RemoveObjectLine) {
        Log.print('Removing ${line.object} from the scene');

        NovelObject object = line.object;
        if (object is BackgroundObject) {
          layers.removeWhere(
            (e) => e is BackgroundObject && e.asset == object.asset,
          );
        } else if (object is BackdropRect) {
          layers.removeWhere((e) => e is BackdropRect);
        } else if (object is CharacterObject) {
          layers.removeWhere(
            (e) => e is CharacterObject && e.asset == object.asset,
          );
        }
      } else if (line is WaitLine) {
        Log.print('Waiting for ${line.duration}');
      } else if (line is MusicLine) {
        Log.print('Playing ${line.asset}');
        ambient.setReleaseMode(ReleaseMode.loop);
        ambient.play(AssetSource('${Novel.musics}/${line.asset}'), volume: 0.4);
      } else if (line is StopMusicLine) {
        Log.print('Stopping any music being played');
        ambient.stop();
      }

      if (line is Awaitable) {
        if (previousVoiceSource == _voiceSource &&
            voice.state != PlayerState.stopped) {
          voice.stop();
        }

        if (line.wait) {
          await line.execute();
        }
      }

      if (line is DialogueLine) {
        layers.removeOf<Dialogue>();
      }
    } while (line != null);

    onEnd?.call();
    Log.print('Thread 0 ended');
  }
}

class ObjectComposition {
  /// [NovelObject]s this [ObjectComposition] contains.
  final RxSplayTreeMap<int, List<NovelObject>> objects = RxSplayTreeMap();

  void add(NovelObject object, [int depth = 0]) {
    List<NovelObject>? list = objects[depth];
    if (list == null) {
      objects[depth] = [object];
    } else {
      objects[depth]?.add(object);
      objects.refresh();
    }
  }

  void remove(NovelObject object) {
    objects.removeWhere((_, v) => v.remove(object));
  }

  void removeOf<T>() {
    objects.removeWhere((_, e) {
      e.removeWhere((m) => m is T);
      return e.isEmpty;
    });
  }

  void removeWhere(bool Function(NovelObject) test) {
    objects.removeWhere((_, e) {
      e.removeWhere(test);
      return e.isEmpty;
    });
  }
}
