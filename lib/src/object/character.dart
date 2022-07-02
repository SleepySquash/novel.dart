import '/src/core/object.dart';

/// Character as a [NovelObject].
class Character extends NovelObject with GuardedMixin {
  Character(
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
