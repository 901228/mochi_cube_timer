import "package:cube_timer/cube_timer.dart";

import "algorithm_data/common.dart";
import "algorithm_data/fto_l3c.dart";
import "algorithm_data/fto_l6x.dart";
import "algorithm_data/oll.dart";
import "algorithm_data/pll.dart";

/// use `id` of [Puzzle] as key to prevent the additional search for the puzzle by puzzleId
typedef AlgorithmSets = Map<String, AlgorithmGroups>;

/// All built-in algorithm sets, across puzzles.
final AlgorithmSets algorithmSets = {
  Puzzle.cube3.id: [
    AlgorithmGroup(
      id: "cfop",
      name: "CFOP",
      sets: [
        AlgorithmSet(id: "pll", name: "PLL", subtitle: "Permutation of the Last Layer", cases: pllCases),
        AlgorithmSet(id: "oll", name: "OLL", subtitle: "Orientation of the Last Layer", cases: ollCases),
      ],
    ),
  ],
  Puzzle.fto.id: [
    AlgorithmGroup(
      id: "nautilus",
      name: "Nautilus",
      sets: [
        AlgorithmSet(id: "l6x", name: "L6X", subtitle: "Last Six Triangles", cases: ftoL6xCases),
        AlgorithmSet(id: "l3c", name: "L3C", subtitle: "Last Three Corners", cases: ftoL3cCases),
      ],
    ),
  ],
};

extension AlgorithmSetsX on AlgorithmSets {
  AlgorithmSet? findSet(String puzzleId, {String? setId}) {
    final groups = this[puzzleId];
    if (groups == null) return null;

    for (final s in groups.flatten()) {
      if (setId == null || s.id == setId) return s;
    }
    return null;
  }
}
