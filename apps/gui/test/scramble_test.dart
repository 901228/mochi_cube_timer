import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("the 4x4x4 is scrambled from a random state, with its tables", () async {
    final scramble = await Puzzle.cube4.getScramble();
    expect(scramble.notation.split(" ").length, inInclusiveRange(30, 60));
    expect(scramble.state, hasLength(96));
  });

  test("the FTO is scrambled with its 72 stickers", () async {
    final scramble = await Puzzle.fto.getScramble();
    expect(scramble.state, hasLength(72));
    expect(scramble.notation, isNotEmpty);
  });
}
