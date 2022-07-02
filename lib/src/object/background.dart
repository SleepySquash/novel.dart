import '/src/core/object.dart';

/// Background as a [NovelObject].
class Background extends NovelObject with GuardedMixin {
  Background(
    this.asset, {
    this.duration = const Duration(milliseconds: 500),
  });

  final String asset;

  final Duration duration;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }
}
