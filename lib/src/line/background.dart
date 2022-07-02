import '/src/core/line.dart';
import '/src/object/background.dart';

class BackgroundLine extends AddObjectLine {
  BackgroundLine(
    String asset, {
    bool wait = true,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(Background(asset, duration: duration), wait: wait);

  @override
  Future<void> execute() => object.init();
}
