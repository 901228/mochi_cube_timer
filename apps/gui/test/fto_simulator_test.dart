import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube/fto.dart";
import "package:mochi_cube_timer_gui/features/simulator/notation.dart";
import "package:mochi_cube_timer_gui/features/simulator/sim_move.dart";
import "package:mochi_cube_timer_gui/features/simulator/simulated_fto.dart";
import "package:mochi_cube_timer_gui/features/simulator/stickering.dart";
import "package:vector_math/vector_math_64.dart";

SimulatedFto _after(String moves, {String setup = ""}) {
  final (s, m) = readSimMoves(ftoPuzzle, setup, moves);
  final fto = SimulatedFto();
  for (final move in [...s, ...m]) {
    fto.turn(move);
  }
  return fto;
}

void _expectClose(Matrix3 a, Matrix3 b, {String? reason}) {
  for (var i = 0; i < 9; i++) {
    expect(a.storage[i], closeTo(b.storage[i], 1e-9), reason: reason);
  }
}

void main() {
  test("the stickers end up as the notation turns them, whole-puzzle turns and all", () {
    for (final text in ["R U' BR2 D", "{U,R} r U' R' br", "{R,D} l2' B {U,L} f", "r u' {BL,D} BR"]) {
      expect(_after(text).facelets, (Fto()..apply(parseFtoNotation(text))).facelets, reason: text);
    }
  });

  test("a setup that turns the puzzle changes what the moves after it name", () {
    expect(_after("U", setup: "{R,D}").facelets, (Fto()..apply(parseFtoNotation("{R,D} U"))).facelets);
    expect(readSimMoves(ftoPuzzle, "{R,D}", "U").$2, [FtoMove(1, (1, 0, 0))]);
  });

  test("the hold a wide turn leaves is the one the notation names faces by", () {
    // {U, F} names the hold the puzzle is already in, so it turns nothing.
    for (final text in ["r", "r u'", "{U,R} br", "{R,D} l2", "f bl'"]) {
      final hold = readSimMoves(ftoPuzzle, "", "$text {U,F}").$2.last as FtoHold;
      _expectClose(hold.to, hold.from, reason: text);
      _expectClose(hold.from, _after(text).hold, reason: text);
    }
  });

  test("{X, Y} holds X up and Y in front, a corner or an edge towards the eye", () {
    final up = Vector3(0, 1, 0);
    for (final (text, upFace, frontFace) in [("{R,D}", 1, 6), ("{U,R}", 0, 1)]) {
      final hold = _after(text).hold;
      expect(hold.transformed(ftoNormal(upFace)).dot(up), closeTo(1, 1e-9), reason: text);
      final front = hold.transformed(ftoNormal(frontFace));
      expect(front.x, closeTo(0, 1e-9), reason: text);
      expect(front.z, greaterThan(0), reason: text);
    }
  });

  test("each move undone leaves the puzzle as it was", () {
    final (_, moves) = readSimMoves(ftoPuzzle, "", "{U,R} r U' {R,D} BR2 bl'");
    final fto = SimulatedFto();
    for (final move in moves) {
      final before = [...fto.facelets];
      final hold = fto.hold.clone();
      fto
        ..turn(move)
        ..turn(move.withAmount(-move.amount));
      expect(fto.facelets, before, reason: "$move");
      _expectClose(fto.hold, hold, reason: "$move");
      fto.turn(move);
    }
  });

  test("inverting keeps {X, Y} as written, and bad tokens are found", () {
    expect(invertNotation("{U, R} R BR2 r'", size: ftoPuzzle), "r BR2' R' {U, R}");
    expect(invalidTokens("{U, R} Q R3 {U,D} bl", size: ftoPuzzle), ["Q", "R3", "{U,D}"]);
    expect(invalidTokens("{U, R}", size: 3), ["{U, R}"]);
  });

  test("turns of one axis in brackets turn at once, the middle layer alone for (r R')", () {
    final (_, moves) = readSimMoves(ftoPuzzle, "", "(r R') (R BL)");
    expect(moves, [FtoMove(1, (0, 1, 0)), FtoMove(1, (1, 0, -1))]);
    expect(_after("(r R') U").facelets, _after("r R' U").facelets);
    expect(_after("(r R') U").hold, _after("r R' U").hold);
  });

  test("the hold picked goes first unseen, and names the faces the moves turn", () {
    final (setup, moves) = readSimMoves(ftoPuzzle, "", "U", heldAs: "{R,D}");
    expect(setup, hasLength(1));
    expect(moves, [FtoMove(1, (1, 0, 0))]);
  });

  test("the stages light the last layer's triangles, then all of it", () {
    List<int> lit(Stickering stage, int lastLayer) => [
      for (var i = 0; i < nFtoFacelets; i++)
        if (stage.litFto(i, lastLayer: lastLayer)) i,
    ];
    // The three triangles of the face and two on each side next to it.
    expect(lit(Stickering.l6x, 0), hasLength(9));
    expect(lit(Stickering.l6x, 0).every((i) => ftoPieceOf(i) == FtoPiece.centre), isTrue);
    // The face's nine, five on each side next to it, and a corner on the three that only meet it at one.
    expect(lit(Stickering.l3c, 6), hasLength(27));
    expect(lit(Stickering.full, 6), hasLength(nFtoFacelets));
  });
}
