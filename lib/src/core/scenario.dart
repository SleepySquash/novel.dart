import 'line.dart';

/// [Line]s representing a [Novel]'s scenario.
class Scenario {
  const Scenario(this.lines);
  final List<Line> lines;

  Line? at(int i) {
    if (lines.length <= i) {
      return null;
    }

    return lines[i];
  }
}
