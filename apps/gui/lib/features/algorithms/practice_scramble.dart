import "dart:math";

import "package:mochi_cube/fto.dart" show parseFtoNotation;
import "package:mochi_cube/nxn.dart";

import "algorithm_data/common.dart";

/// [moves] with each run of turns of one block merged, and any that come to nothing left out.
List<int> _merged(Iterable<int> moves) {
  final out = <int>[];
  for (final move in moves) {
    if (out.isNotEmpty && out.last ~/ 3 == move ~/ 3) {
      final quarters = (out.removeLast() % 3 + move % 3 + 2) % 4;
      if (quarters != 0) out.add(move ~/ 3 * 3 + quarters - 1);
    } else {
      out.add(move);
    }
  }
  return out;
}

/// Whether [puzzleId] has practice scrambles: the cubes, and the FTO.
bool canPractice(String puzzleId) => practiceCubeSize(puzzleId) != null || puzzleId == "fto";

/// The puzzles the practice scrambles are made for, by the size of the cube.
int? practiceCubeSize(String puzzleId) => switch (puzzleId) {
  "222" => 2,
  "333" => 3,
  "444" => 4,
  "555" => 5,
  "666" => 6,
  "777" => 7,
  _ => null,
};

/// A scramble that leaves the cube of [size] (solved but for the case) where [item]'s first algorithm that can
/// be read solves it: the algorithm undone. With [auf], a random turn of U before and after, so a last-layer
/// case comes up at any angle.
String practiceScramble(AlgorithmCase item, int size, {bool auf = false, Random? random}) {
  random ??= Random();
  FormatException? error;
  for (final alg in item.algorithms) {
    try {
      final undo = parseCubeNotation(alg, size: size).inverse;
      // A random turn of U, as moves: none, or U, U2 or U', U being the first face.
      List<int> u() => [if (random!.nextInt(4) case final q when q != 0) q - 1];
      return Algorithm(
        _merged([if (auf) ...u(), ...undo, if (auf) ...u()]),
        moveSet: undo.moveSet,
      ).toString();
    } on FormatException catch (e) {
      error = e;
    }
  }
  throw error ?? FormatException("no algorithm", item.id);
}

/// The practice of 3x3's cross: no cases to pick from, so it is not an algorithm set; it has the ordinary
/// scrambles, and its solves are kept apart from the puzzle's own under this id.
const crossDrillId = "cross";

/// A scramble that leaves the FTO (solved but for the case) where [item]'s first algorithm solves it: the
/// algorithm undone.
String ftoPracticeScramble(AlgorithmCase item) => parseFtoNotation(item.algorithms.first).inverse.toString();
