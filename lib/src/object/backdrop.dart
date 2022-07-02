import '/src/core/object.dart';

class BackdropRect extends NovelObject with GuardedMixin {
  BackdropRect({this.duration = const Duration(milliseconds: 300)});

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }
}
