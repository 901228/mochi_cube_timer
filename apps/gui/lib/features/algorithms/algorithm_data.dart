import "package:cube_timer/cube_timer.dart";

import "algorithm_data/common.dart";
import "algorithm_data/oll.dart";
import "algorithm_data/pll.dart";

/// use `id` of [Puzzle] as key to prevent the additional search for the puzzle by puzzleId
typedef AlgorithmSets = Map<String, AlgorithmGroups>;

/// All built-in algorithm sets, across puzzles.
final AlgorithmSets algorithmSets = {
  Puzzle.cube3.id: [
    AlgorithmGroup(
      id: "pll",
      name: "PLL",
      sets: [
        AlgorithmSet(
          id: "pll",
          name: "PLL",
          subtitle: "Permutation of the Last Layer",
          puzzle: .cube3,
          cases: pllCases,
        ),
      ],
    ),
    AlgorithmGroup(
      id: "oll",
      name: "OLL",
      sets: [
        AlgorithmSet(
          id: "oll",
          name: "OLL",
          subtitle: "Orientation of the Last Layer",
          puzzle: .cube3,
          cases: ollCases,
        ),
      ],
    ),
  ],
};

extension AlgorithmSetsX on AlgorithmSets {
  AlgorithmSet? findSet(String puzzleId, {String? setId}) {
    if (!containsKey(puzzleId)) return null;

    final group = this[puzzleId]!;
    for (final s in group.flatten()) {
      if (s.puzzle.id == puzzleId && (setId == null || s.id == setId)) return s;
    }
    return null;
  }
}
