import 'package:flutter/widgets.dart' show BuildContext, GlobalKey, Widget;
import 'package:mutex/mutex.dart';

/// Asset of a novel existing on a scene.
abstract class NovelObject {
  NovelObject();

  GlobalKey key = GlobalKey();

  Future<void> init() => Future.value();
  Future<void> dispose() => Future.value();
  Widget build(BuildContext context);
}

mixin GuardedMixin {
  final Mutex guard = Mutex();
  void unlock() {
    if (guard.isLocked) {
      guard.release();
    }
  }
}
