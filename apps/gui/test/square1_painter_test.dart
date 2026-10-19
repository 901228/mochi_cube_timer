import "dart:ui";

import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/shared/puzzles/square1_painter.dart";

void main() {
  final layout = Puzzle.sq1.scrambler.layout as Square1Layout;
  final solved = Puzzle.sq1.scrambler.solvedState;
  Square1Painter painter({required bool horizontal}) => Square1Painter(
    layout: layout,
    state: solved,
    colors: List.filled(6, const Color(0xFF000000)),
    horizontal: horizontal,
  );

  test("side by side is wide and stacked is tall", () {
    expect(painter(horizontal: true).aspectRatio, greaterThan(1));
    expect(painter(horizontal: false).aspectRatio, lessThan(1));
  });

  test("every sticker stays inside the picture, however the layers are turned", () async {
    for (final horizontal in [true, false]) {
      for (var i = 0; i < 40; i++) {
        final scramble = await Puzzle.sq1.getScramble();
        final p = Square1Painter(
          layout: layout,
          state: scramble.state,
          colors: List.filled(6, const Color(0xFF000000)),
          horizontal: horizontal,
        );
        for (final (polygon, _) in p.polygonsForTest) {
          for (final (x, y) in polygon) {
            expect(x, inInclusiveRange(-0.001, p.pictureWidth + 0.001), reason: scramble.notation);
            expect(y, inInclusiveRange(-0.001, p.pictureHeight + 0.001), reason: scramble.notation);
          }
        }
      }
    }
  });

  test("corners pointing at the bar from both layers do not meet", () async {
    for (var i = 0; i < 40; i++) {
      final scramble = await Puzzle.sq1.getScramble();
      final p = Square1Painter(
        layout: layout,
        state: scramble.state,
        colors: List.filled(6, const Color(0xFF000000)),
      );
      final h = p.pictureHeight;
      double centre(List<Point> polygon) => polygon.map((q) => q.$2).reduce((a, b) => a + b) / polygon.length;
      final top = [
        for (final (polygon, _) in p.polygonsForTest)
          if (centre(polygon) < h / 3) polygon,
      ];
      final bottom = [
        for (final (polygon, _) in p.polygonsForTest)
          if (centre(polygon) > 2 * h / 3) polygon,
      ];
      final topReach = top.expand((polygon) => polygon.map((q) => q.$2)).reduce((a, b) => a > b ? a : b);
      final bottomReach = bottom
          .expand((polygon) => polygon.map((q) => q.$2))
          .reduce((a, b) => a < b ? a : b);
      expect(bottomReach - topReach, greaterThanOrEqualTo(0.1 - 0.001), reason: scramble.notation);
    }
  });
}
