import "common.dart";

/// Ortega PBL: permute both layers of a 2x2. From SpeedCubeDB.
const List<AlgorithmCase> ortegaPblCases = [
  AlgorithmCase(
    id: "adj",
    name: "Adj",
    group: "All",
    algorithms: [
      "y R U R' F' R U R' U' R' F R2 U' R'",
      "y R' F R F' R U2 R' U R U2 R'",
      "y R U R' U' R' F R2 U' R' U' R U R' F'",
      "y2 R' F R' F2 R U' R' F2 R2",
    ],
  ),
  AlgorithmCase(
    id: "opp",
    name: "Opp",
    group: "All",
    algorithms: [
      "R U' R' U' F2 U' R U R' U F2",
      "F R U' R' U' R U R' F' R U R' U' R' F R F'",
      "R U' R' U' F2 U' R U R' D R2",
      "F R' F R2 U' R' U' R U R' F' R U R' U' F'",
    ],
  ),
  AlgorithmCase(
    id: "opp-opp",
    name: "Opp Opp",
    group: "All",
    algorithms: ["R2 F2 R2", "R2 B2 R2", "x R2 U2 R2", "x' R2 U2 R2"],
  ),
  AlgorithmCase(
    id: "adj-adj",
    name: "Adj Adj",
    group: "All",
    algorithms: [
      "R2 U' B2 U2 R2 U' R2",
      "y2 R2 U' R2 U2 F2 U' R2",
      "R2 U R2 U2 F2 U F2",
      "R2 U' F2 U2 R2 U' B2",
    ],
  ),
  AlgorithmCase(
    id: "adj-opp",
    name: "Adj Opp",
    group: "All",
    algorithms: ["R U' R F2 R' U R'", "R' F R' F2 R U' R", "y2 R' U R' F2 R F' R", "y2 R' U L' U2 R U' L"],
  ),
  AlgorithmCase(
    id: "opp-adj",
    name: "Opp Adj",
    group: "All",
    algorithms: [
      "y R2 U R2 U' R2 U R2 U' R2",
      "R' D R' F2 R D' R",
      "z2 R U' R F2 R' U R'",
      "y R2 U' R2 U R2 U' R2 U R2",
    ],
  ),
];
