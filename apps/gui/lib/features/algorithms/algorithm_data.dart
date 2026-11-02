import "package:cube_timer/cube_timer.dart";

import "alg_scale.dart";
import "algorithm_data/big_cube_l2c.dart";
import "algorithm_data/big_cube_l2e.dart";
import "algorithm_data/big_cube_oll_parity.dart";
import "algorithm_data/big_cube_pll_parity.dart";
import "algorithm_data/common.dart";
import "algorithm_data/cube2_cll.dart";
import "algorithm_data/cube2_ortega_oll.dart";
import "algorithm_data/cube2_ortega_pbl.dart";
import "algorithm_data/cube3_coll.dart";
import "algorithm_data/cube3_f2l.dart";
import "algorithm_data/cube3_sv.dart";
import "algorithm_data/cube3_wv.dart";
import "algorithm_data/fto_l3c.dart";
import "algorithm_data/fto_l6x.dart";
import "algorithm_data/oll.dart";
import "algorithm_data/pll.dart";

/// use `id` of [Puzzle] as key to prevent the additional search for the puzzle by puzzleId
typedef AlgorithmSets = Map<String, AlgorithmGroups>;

/// 4x4 parity, written for 4x4 and scaled to the other even cubes.
const _parity = AlgorithmGroup(
  id: "parity",
  name: "Parity",
  sets: [
    AlgorithmSet(
      id: "oll-parity",
      name: "OLL Parity",
      subtitle: "Flip a single dedge",
      cases: ollParityCases,
    ),
    AlgorithmSet(
      id: "pll-parity",
      name: "PLL Parity",
      subtitle: "PLL with two dedges swapped",
      cases: pllParityCases,
    ),
  ],
);

/// 5x5 edge pairing, written for 5x5 and scaled to the other odd cubes.
const _edges = AlgorithmGroup(
  id: "edges",
  name: "Edges",
  sets: [AlgorithmSet(id: "l2e", name: "L2E", subtitle: "Last Two Edges", cases: l2eCases)],
);

/// 5x5 last two centers, written for 5x5 and scaled to the other odd cubes.
const _centers = AlgorithmGroup(
  id: "centers",
  name: "Centers",
  sets: [AlgorithmSet(id: "l2c", name: "L2C", subtitle: "Last Two Centers", cases: l2cCases)],
);

/// All built-in algorithm sets, across puzzles.
final AlgorithmSets algorithmSets = {
  Puzzle.cube2.id: [
    AlgorithmGroup(
      id: "ortega",
      name: "Ortega",
      sets: [
        AlgorithmSet(
          id: "ortega-oll",
          name: "OLL",
          subtitle: "Orientation of the Last Layer",
          cases: ortegaOllCases,
        ),
        AlgorithmSet(
          id: "ortega-pbl",
          name: "PBL",
          subtitle: "Permutation of Both Layers",
          cases: ortegaPblCases,
        ),
      ],
    ),
    AlgorithmGroup(
      id: "cll",
      name: "CLL",
      sets: [AlgorithmSet(id: "cll", name: "CLL", subtitle: "Corners of the Last Layer", cases: cllCases)],
    ),
  ],
  Puzzle.cube3.id: [
    AlgorithmGroup(
      id: "cfop",
      name: "CFOP",
      sets: [
        AlgorithmSet(id: "f2l", name: "F2L", subtitle: "First Two Layers", cases: f2lCases),
        AlgorithmSet(id: "pll", name: "PLL", subtitle: "Permutation of the Last Layer", cases: pllCases),
        AlgorithmSet(id: "oll", name: "OLL", subtitle: "Orientation of the Last Layer", cases: ollCases),
      ],
    ),
    AlgorithmGroup(
      id: "last-slot",
      name: "Last Slot",
      sets: [
        AlgorithmSet(id: "wv", name: "WV", subtitle: "Winter Variation", cases: wvCases),
        AlgorithmSet(id: "sv", name: "SV", subtitle: "Summer Variation", cases: svCases),
      ],
    ),
    AlgorithmGroup(
      id: "last-layer",
      name: "Last Layer",
      sets: [
        AlgorithmSet(
          id: "coll",
          name: "COLL",
          subtitle: "Corners and Orientation of the Last Layer",
          cases: collCases,
        ),
      ],
    ),
  ],
  Puzzle.cube4.id: [_parity],
  Puzzle.cube5.id: [_centers, _edges],
  Puzzle.cube6.id: [_parity.scaledTo(from: 4, to: 6)],
  Puzzle.cube7.id: [_centers.scaledTo(from: 5, to: 7), _edges.scaledTo(from: 5, to: 7)],
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
