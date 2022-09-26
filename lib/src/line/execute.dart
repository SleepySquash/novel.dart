import '/src/core/line.dart';

class ExecuteLine extends Line with Awaitable {
  const ExecuteLine(this.function);

  final Future<void> Function() function;

  @override
  bool get wait => true;

  @override
  Future<void> execute() => function();
}
