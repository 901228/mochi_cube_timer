import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube/fto/cube.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithm_data.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithm_data/common.dart";
import "package:mochi_cube_timer_gui/features/algorithms/practice_scramble.dart";

AlgorithmCase _case(String alg) => AlgorithmCase(id: "t", name: "t", group: "t", algorithms: [alg]);

/// Whether D is all D's colour and each side is one colour below its top row; which side colour is where is
/// up to the algorithm, as an even cube has no centres to tell.
bool _belowTopSolved(List<int> state, int n) {
  if (state.sublist(3 * n * n, 4 * n * n).any((c) => c != 3)) return false;
  for (final face in [1, 2, 4, 5]) {
    if (state.sublist(face * n * n + n, (face + 1) * n * n).toSet().length != 1) return false;
  }
  return true;
}

void main() {
  test("rotations, slices and wide turns become turns of a cube held still", () {
    expect(practiceScramble(_case("R U R' U'"), 3), "U R U' R'");
    expect(practiceScramble(_case("y' R"), 3), "F'");
    expect(practiceScramble(_case("M2"), 3), "L2 R2");
    expect(practiceScramble(_case("r U"), 3), "F' L'");
    expect(practiceScramble(_case("2R U"), 4), "U' R Rw'");
    expect(practiceScramble(_case("3Rw U"), 5), "F' Lw'");
  });

  test("the scrambles of every last-layer set leave the rest of the cube solved", () {
    final bad = <String>[];
    for (final MapEntry(key: puzzleId, value: groups) in algorithmSets.entries) {
      final n = practiceCubeSize(puzzleId);
      if (n == null) continue;
      final scrambler = Puzzle.values.firstWhere((p) => p.id == puzzleId).scrambler;
      for (final set in groups.flatten()) {
        for (final item in set.cases) {
          final scramble = practiceScramble(item, n, auf: set.lastLayer);
          final state = scrambler.parse(scramble).state;
          // PBL turns D too, so only the sets of the last layer alone are checked.
          if (set.lastLayer && set.id != "ortega-pbl") {
            if (!_belowTopSolved(state, n)) {
              bad.add("$puzzleId ${set.id} ${item.id}: ${item.algorithms.first}");
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test("every FTO algorithm undone leaves one layer to solve", () {
    // A face's layer: the stickers its turn moves, and its own, which keep their colour.
    final layers = [
      for (var f = 0; f < 8; f++)
        {
          for (final (k, c) in (Fto()..turn(f, 1)).facelets.indexed)
            if (c != k ~/ 9 || k ~/ 9 == f) k,
        },
    ];
    final bad = <String>[];
    for (final set in algorithmSets["fto"]!.flatten()) {
      for (final item in set.cases) {
        final scramble = ftoPracticeScramble(item);
        Puzzle.fto.scrambler.parse(scramble);
        final state = Fto();
        for (final move in scramble.split(" ")) {
          state.turn(ftoFaceNames.indexOf(move.replaceAll("'", "")), move.endsWith("'") ? 2 : 1);
        }
        final wrong = {
          for (final (k, c) in state.facelets.indexed)
            if (c != k ~/ 9) k,
        };
        if (wrong.isEmpty || !layers.any((l) => wrong.difference(l).isEmpty)) bad.add("${set.id} ${item.id}");
      }
    }
    expect(bad, isEmpty);
  });
}
