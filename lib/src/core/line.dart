import 'object.dart';
import 'scenario.dart';

/// Single line of a [Scenario] representing some action.
abstract class Line {
  const Line();

  /// Executes this [Line].
  Future<void> execute() => Future.value();
}

mixin Awaitable on Line {
  bool get wait;
}

/// [Line] adding the provided [object] to the scene.
class AddObjectLine extends Line with Awaitable {
  const AddObjectLine(
    this.object, {
    this.wait = true,
    this.depth = 0,
  });

  final int depth;
  final NovelObject object;

  @override
  final bool wait;

  @override
  Future<void> execute() => object.init();
}

/// [Line] removing the provided [object] from the scene.
class RemoveObjectLine extends Line {
  const RemoveObjectLine(this.object, {this.wait = true});

  final NovelObject object;

  final bool wait;

  @override
  Future<void> execute() => object.init();
}
