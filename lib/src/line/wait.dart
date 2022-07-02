import '/src/core/line.dart';

/// [Line] waiting the provided [duration].
class WaitLine extends Line with Awaitable {
  const WaitLine(this.duration);

  final Duration duration;

  @override
  bool get wait => true;

  @override
  Future<void> execute() => Future.delayed(duration);
}
