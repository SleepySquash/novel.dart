import '/src/core/object.dart';

/// Dialog as a [NovelObject].
class Dialogue extends NovelObject with GuardedMixin {
  Dialogue({
    this.by,
    required this.text,
  });

  final String? by;
  final String text;

  @override
  Future<void> init() async {
    await guard.acquire();
    return guard.acquire();
  }
}
