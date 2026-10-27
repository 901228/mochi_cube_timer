import "../ll_painter.dart";
import "common.dart";

/// All 21 PLL cases with arrows and multiple standard algorithms.
final List<AlgorithmCase> pllCases = [
  // Edges Only (4)
  const AlgorithmCase(
    id: "ua",
    name: "Ua",
    group: "Edges Only",
    pllArrows: [PllArrow(5, 3), PllArrow(7, 5), PllArrow(3, 7)],
    algorithms: ["R U' R U R U R U' R' U' R2", "M2 U M U2 M' U M2", "R2 U' R' U' R U R U R U' R"],
  ),
  const AlgorithmCase(
    id: "ub",
    name: "Ub",
    group: "Edges Only",
    pllArrows: [PllArrow(3, 5), PllArrow(5, 7), PllArrow(7, 3)],
    algorithms: ["R2 U R U R' U' R' U' R' U R'", "M2 U' M U2 M' U' M2", "R' U R' U' R' U' R' U R U R2"],
  ),
  const AlgorithmCase(
    id: "h",
    name: "H",
    group: "Edges Only",
    pllArrows: [PllArrow(1, 7, bidirectional: true), PllArrow(3, 5, bidirectional: true)],
    algorithms: ["M2 U M2 U2 M2 U M2", "M2 U' M2 U2 M2 U' M2", "R2 U2 R U2 R2 U2 R2 U2 R U2 R2"],
  ),
  const AlgorithmCase(
    id: "z",
    name: "Z",
    group: "Edges Only",
    pllArrows: [PllArrow(5, 1, bidirectional: true), PllArrow(7, 3, bidirectional: true)],
    algorithms: [
      "M' U M2 U M2 U M' U2 M2",
      "M2 U M2 U M' U2 M2 U2 M'",
      "R' U' R U' R U R U' R' U R U R2 U' R'",
    ],
  ),

  // Corners Only (3)
  const AlgorithmCase(
    id: "aa",
    name: "Aa",
    group: "Corners Only",
    pllArrows: [PllArrow(0, 2), PllArrow(8, 0), PllArrow(2, 8)],
    algorithms: [
      "x R' U R' D2 R U' R' D2 R2 x'",
      "x L2 D2 L' U' L D2 L' U L' x'",
      "R' F R' B2 R F' R' B2 R2",
    ],
  ),
  const AlgorithmCase(
    id: "ab",
    name: "Ab",
    group: "Corners Only",
    pllArrows: [PllArrow(2, 0), PllArrow(0, 8), PllArrow(8, 2)],
    algorithms: ["x R2 D2 R U R' D2 R U' R x'", "x' R U' R D2 R' U R D2 R2 x", "R2 B2 R F R' B2 R F' R"],
  ),
  const AlgorithmCase(
    id: "e",
    name: "E",
    group: "Corners Only",
    pllArrows: [PllArrow(2, 8, bidirectional: true), PllArrow(0, 6, bidirectional: true)],
    algorithms: [
      "x' R U' R' D R U R' D' R U R' D R U' R' D' x",
      "R2 U R' U' y R U R' U' R U R' U' R U R' y' R U' R2",
    ],
  ),

  // Adjacent Corner Swap (10)
  const AlgorithmCase(
    id: "t",
    name: "T",
    group: "Adjacent Corner Swap",
    pllArrows: [PllArrow(8, 2, bidirectional: true), PllArrow(3, 5, bidirectional: true)],
    algorithms: ["R U R' U' R' F R2 U' R' U' R U R' F'", "R U R' U' R' F R2 U' R' U F' L' U L"],
  ),
  const AlgorithmCase(
    id: "f",
    name: "F",
    group: "Adjacent Corner Swap",
    pllArrows: [PllArrow(2, 8, bidirectional: true), PllArrow(1, 7, bidirectional: true)],
    algorithms: [
      "R' U' F' R U R' U' R' F R2 U' R' U' R U R' U R",
      "R' U2 R' Dw' R' F' R2 U' R' U R' F R U' F",
    ],
  ),
  const AlgorithmCase(
    id: "ja",
    name: "Ja",
    group: "Adjacent Corner Swap",
    pllArrows: [PllArrow(8, 2, bidirectional: true), PllArrow(5, 1, bidirectional: true)],
    algorithms: [
      "x R2 F R F' R U2 Rw' U Rw U2 x'",
      "R' U L' U2 R U' R' U2 R L",
      "L' U' L F L' U' L U L F' L2 U L",
    ],
  ),
  const AlgorithmCase(
    id: "jb",
    name: "Jb",
    group: "Adjacent Corner Swap",
    pllArrows: [PllArrow(2, 8, bidirectional: true), PllArrow(5, 7, bidirectional: true)],
    algorithms: ["R U R' F' R U R' U' R' F R2 U' R'", "R U2 R' U' R U2 L' U R' U' L"],
  ),
  const AlgorithmCase(
    id: "ra",
    name: "Ra",
    group: "Adjacent Corner Swap",
    pllArrows: [PllArrow(8, 2, bidirectional: true), PllArrow(3, 1, bidirectional: true)],
    algorithms: [
      "R U' R' U' R U R D R' U' R D' R' U2 R'",
      "R U R' F' R U2 R' U2 R' F R U R U2 R'",
      "L U2 L' U2 L F' L' U' L U L F L2",
    ],
  ),
  const AlgorithmCase(
    id: "rb",
    name: "Rb",
    group: "Adjacent Corner Swap",
    pllArrows: [PllArrow(2, 8, bidirectional: true), PllArrow(3, 7, bidirectional: true)],
    algorithms: ["R' U2 R U2 R' F R U R' U' R' F' R2", "R' U2 R' D' R U' R' D R U R U' R' U' R"],
  ),
  const AlgorithmCase(
    id: "ga",
    name: "Ga",
    group: "Adjacent Corner Swap",
    pllArrows: [
      PllArrow(0, 2),
      PllArrow(2, 6),
      PllArrow(6, 0),
      PllArrow(3, 5),
      PllArrow(5, 1),
      PllArrow(1, 3),
    ],
    algorithms: ["R2 U R' U R' U' R U' R2 U' D R' U R D'", "R2 Uw R' U R' U' R Uw' R2 y' R' U R"],
  ),
  const AlgorithmCase(
    id: "gb",
    name: "Gb",
    group: "Adjacent Corner Swap",
    pllArrows: [
      PllArrow(6, 8),
      PllArrow(8, 0),
      PllArrow(0, 6),
      PllArrow(1, 7),
      PllArrow(7, 3),
      PllArrow(3, 1),
    ],
    algorithms: ["R' U' R U D' R2 U R' U R U' R U' R2 D", "R' U' R y R2 Uw R' U R U' R Uw' R2"],
  ),
  const AlgorithmCase(
    id: "gc",
    name: "Gc",
    group: "Adjacent Corner Swap",
    pllArrows: [
      PllArrow(6, 8),
      PllArrow(8, 0),
      PllArrow(0, 6),
      PllArrow(3, 5),
      PllArrow(5, 7),
      PllArrow(7, 3),
    ],
    algorithms: [
      "R2 U' R U' R U R' U R2 U D' R U' R' D",
      "R2 Uw' R U' R U R' Uw R2 y R U' R'",
      "R2 F2 R U2 R U2 R' F R U R' U' R' F R2",
    ],
  ),
  const AlgorithmCase(
    id: "gd",
    name: "Gd",
    group: "Adjacent Corner Swap",
    pllArrows: [
      PllArrow(0, 2),
      PllArrow(2, 6),
      PllArrow(6, 0),
      PllArrow(7, 1),
      PllArrow(1, 3),
      PllArrow(3, 7),
    ],
    algorithms: ["R U R' U' D R2 U' R U' R' U R' U R2 D'", "R U R' y' R2 Uw' R U' R' U R' Uw R2"],
  ),

  // Diagonal Corner Swap (4)
  const AlgorithmCase(
    id: "v",
    name: "V",
    group: "Diagonal Corner Swap",
    pllArrows: [PllArrow(8, 0, bidirectional: true), PllArrow(1, 5, bidirectional: true)],
    algorithms: [
      "R' U R' U' y R' F' R2 U' R' U R' F R F",
      "R' U R' U' R D' R' D R' U D' R2 U' R2 D R2",
      "R U' R U R' D R D' R U' D R2 U R2 D' R2",
    ],
  ),
  const AlgorithmCase(
    id: "y",
    name: "Y",
    group: "Diagonal Corner Swap",
    pllArrows: [PllArrow(8, 0, bidirectional: true), PllArrow(3, 1, bidirectional: true)],
    algorithms: ["F R U' R' U' R U R' F' R U R' U' R' F R F'", "F R' F R2 U' R' U' R U R' F' R U R' U' F'"],
  ),
  const AlgorithmCase(
    id: "na",
    name: "Na",
    group: "Diagonal Corner Swap",
    pllArrows: [PllArrow(6, 2, bidirectional: true), PllArrow(5, 3, bidirectional: true)],
    algorithms: [
      "R U R' U R U R' F' R U R' U' R' F R2 U' R' U2 R U' R'",
      "L U' R U2 L' U R' L U' R U2 L' U R'",
    ],
  ),
  const AlgorithmCase(
    id: "nb",
    name: "Nb",
    group: "Diagonal Corner Swap",
    pllArrows: [PllArrow(0, 8, bidirectional: true), PllArrow(5, 3, bidirectional: true)],
    algorithms: ["R' U R U' R' F' U' F R U R' F R' F' R U' R", "R' U L' U2 R U' L R' U L' U2 R U' L"],
  ),
];
