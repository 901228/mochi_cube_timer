import "common.dart";

/// L2E: pair the last two edges of a 5x5. From SpeedCubeDB.
const List<AlgorithmCase> l2eCases = [
  AlgorithmCase(id: "l2e-1", name: "L2E 1", group: "All", algorithms: ["Rw' U' R' U R' F R F' Rw"]),
  AlgorithmCase(
    id: "l2e-2",
    name: "L2E 2",
    group: "All",
    algorithms: ["Lw U' R' U R' F R F' Lw'", "z y Uw F' D' F D' L D L' Uw' y' z'"],
  ),
  AlgorithmCase(
    id: "l2e-3",
    name: "L2E 3",
    group: "All",
    algorithms: [
      "x' M' U' R' U R' F R F' M x",
      "r' l U' R' U R' F R F' r l'",
      "x' z' E' L' U' L U' F U F' E z x",
    ],
  ),
  AlgorithmCase(
    id: "l2e-4",
    name: "L2E 4",
    group: "All",
    algorithms: [
      "Rw2 F2 U2 Rw2 U2 F2 Rw2",
      "Rw2 F2 U2 r2 U2 F2 Rw2",
      "z' y' Uw2' R2 F2 Uw2' F2 R2' Uw2'",
      "y x' Uw2 L2 F2 Uw2 F2 L2 Uw2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-5",
    name: "L2E 5",
    group: "All",
    algorithms: [
      "Rw2 B2 Rw' U2 Rw' U2' x' U2 Rw' U2' Rw U2 Rw' U2' Rw2 U2 x",
      "r2 B2 r' U2 r' U2 x' U2 r' U2 r U2 r' U2 r2 U2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-6",
    name: "L2E 6",
    group: "All",
    algorithms: [
      "Rw' U2 3Rw U2 3Rw' F2 Rw2 U2 Rw U2 Rw' U2 F2 Rw2 F2",
      "Rw U2 x Rw U2 Rw U2 3Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw'",
      "Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 3Rw' U2 Rw U2 Rw' U2 Rw'",
      "Rw2 B2 U2 Lw U2 Rw' U2 Rw U2 F2 Rw F2 Lw' B2 Rw2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-7",
    name: "L2E 7",
    group: "All",
    algorithms: [
      "y2 Rw U2 Rw U2' x U2 Rw U2' 3Rw' U2 Lw U2' Rw2",
      "Lw' U2 Lw' U2 F2 Lw' F2 Rw U2 Rw' U2 Lw2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-8",
    name: "L2E 8",
    group: "All",
    algorithms: [
      "Lw2 F2 U2 Lw' U2 Lw2 F2 Lw' U2 Lw2 U2 F2 Lw' F2",
      "l2 F2 U2 r U2 r2 F2 r U2 l2 U2 F2 l' F2",
      "F2 Rw U2 Rw U2' Rw' F2 Rw' U2 Rw' U2' Rw U2 Rw' U2' Rw2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-9",
    name: "L2E 9",
    group: "All",
    algorithms: [
      "B2 Rw' U2 Rw' U2' Rw B2 Rw U2 Rw U2' Rw' U2 Rw U2' Rw2",
      "r2 F2 U2 r U2 r2 F2 r U2 r2 U2 F2 r F2",
      "x' U2 Rw U2 Rw U2' Rw' F2 Rw' U2 Rw' U2' Rw U2 Rw' U2' Rw2 U2 F2 U2 F2 x",
      "Rw2 F2 U2 Lw' U2 Lw2 F2 Lw' U2 Rw2 U2 F2 Rw F2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-10",
    name: "L2E 10",
    group: "All",
    algorithms: ["Rw' U2 Rw2 U2 Rw U2 Rw' U2 Rw U2 Rw2 U2 Rw'"],
  ),
  AlgorithmCase(
    id: "l2e-11",
    name: "L2E 11",
    group: "All",
    algorithms: ["Rw U2 Rw2 U2 Rw' U2 Rw U2 Rw' U2 Rw2 U2 Rw"],
  ),
  AlgorithmCase(
    id: "l2e-12",
    name: "L2E 12",
    group: "All",
    algorithms: [
      "Rw' U2 Rw U2 3Lw' U2 Rw U2 Rw U2' Rw' U2 Rw U2' Rw2 D2 F2 U2 D2",
      "Rw' U2 Rw' U2 B2 Rw' B2 Rw' F2 Lw2 F2 Rw U2 Rw2",
    ],
  ),
  AlgorithmCase(
    id: "l2e-13",
    name: "L2E 13",
    group: "All",
    algorithms: ["Rw U R U' Rw2 U' R U Rw2 U R U' Rw'", "r U R' U' r2 U' R' U r2 U R' U' r'"],
  ),
];
