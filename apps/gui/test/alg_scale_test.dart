import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/algorithms/alg_scale.dart";

void main() {
  test("4x4 moves widen to the whole inner block on even cubes", () {
    expect(scaleAlg("R U2' F'", from: 4, to: 6), "R U2' F'");
    expect(scaleAlg("Rw U2 Lw'", from: 4, to: 6), "3Rw U2 3Lw'");
    expect(scaleAlg("r2 u", from: 4, to: 6), "3Rw2 3Uw");
    expect(scaleAlg("2R2 U2 2R'", from: 4, to: 6), "3Rw2 R2 U2 3Rw' R");
    expect(scaleAlg("2R", from: 4, to: 8), "4Rw R'");
    expect(scaleAlg("3R", from: 4, to: 6), "5Rw 3Rw'");
  });

  test("5x5 moves keep the middle layer on odd cubes", () {
    expect(scaleAlg("Rw' 3Rw Lw", from: 5, to: 7), "3Rw' 4Rw 3Lw");
    expect(scaleAlg("2L'", from: 5, to: 7), "3Lw' L");
    expect(scaleAlg("3R", from: 5, to: 7), "4Rw 3Rw'");
    expect(scaleAlg("x' M' E2 S y", from: 5, to: 7), "x' M' E2 S y");
  });

  test("same size is untouched, bad input fails loudly", () {
    expect(scaleAlg("(R U)", from: 4, to: 4), "(R U)");
    expect(() => scaleAlg("R U", from: 4, to: 5), throwsArgumentError);
    expect(() => scaleAlg("R U", from: 6, to: 8), throwsArgumentError);
    expect(() => scaleAlg("5R", from: 4, to: 6), throwsFormatException);
    expect(() => scaleAlg("R (U)", from: 4, to: 6), throwsFormatException);
  });

  test("stickers stretch so the inner layers that move together share a colour", () {
    // 4x4 -> 6x6: rows and columns 1 and 2 become 1..2 and 3..4.
    const top =
        "abcd"
        "efgh"
        "ijkl"
        "mnop";
    final big = scaleStickers(
      "$top"
      "BBBB"
      "RRRR"
      "FFFF"
      "LLLL",
      from: 4,
      to: 6,
    );
    expect(big, hasLength(6 * 6 + 4 * 6));
    expect(big.substring(0, 6), "abbccd");
    expect(big.substring(6, 12), "effggh");
    expect(
      big.substring(36),
      "BBBBBB"
      "RRRRRR"
      "FFFFFF"
      "LLLLLL",
    );
    expect(scaleStickers(top + "x" * 16, from: 4, to: 4), top + "x" * 16);
  });

  test("stickers stretch face by face, whatever the number of faces", () {
    // 5x5 -> 7x7: rows 1 and 3 become two rows each, the middle row stays one.
    final face = [for (var i = 0; i < 25; i++) String.fromCharCode(97 + i)].join();
    final big = scaleFaceStickers(face * 3, from: 5, to: 7);
    expect(big, hasLength(3 * 49));
    expect(scaleFaceStickers(face * 2, from: 5, to: 7), hasLength(2 * 49));
    expect(big.substring(0, 7), "abbcdde");
    expect(big.substring(7, 14), "fgghiij");
    expect(big.substring(49, 56), "abbcdde");
  });
}
