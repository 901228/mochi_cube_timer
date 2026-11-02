import "common.dart";

/// Ortega OLL: orient the last layer of a 2x2. From SpeedCubeDB.
const List<AlgorithmCase> ortegaOllCases = [
  AlgorithmCase(
    id: "sune",
    name: "Sune",
    group: "All",
    cubeStickers: "ogyryrybbygo",
    algorithms: ["R U R' U R U2 R'", "R U R2 U' R2 U R", "R U' L' U R' U' L", "y' R' U2 R U R' U R"],
  ),
  AlgorithmCase(
    id: "anti-sune",
    name: "Anti Sune",
    group: "All",
    cubeStickers: "gyobogryyryb",
    algorithms: ["R U2 R' U' R U' R'", "y L' U' L U' L' U2 L", "y' R' U' R U' R' U2 R", "R' F R F' R U R'"],
  ),
  AlgorithmCase(
    id: "pi",
    name: "Pi",
    group: "All",
    cubeStickers: "bogorybgryyy",
    algorithms: [
      "F R U R' U' R U R' U' F'",
      "R U' R2 U R2 U R2 U' R",
      "R U2 R2 U' R2 U' R2 U2 R",
      "y' R' F R2 U' R2 F R",
    ],
  ),
  AlgorithmCase(
    id: "p",
    name: "P",
    group: "All",
    cubeStickers: "oyoybrbggryy",
    algorithms: [
      "F R U R' U' F'",
      "y2 F U R U' R' F'",
      "y' R2 D R' U2 R D' R' U2 R'",
      "y R2 D' R U2 R' D R U2 R",
    ],
  ),
  AlgorithmCase(
    id: "l",
    name: "L",
    group: "All",
    cubeStickers: "ygbygrybyoor",
    algorithms: [
      "y F' R U R' U' R' F R",
      "F R U' R' U' R U R' F'",
      "F R' F' R U R U' R'",
      "F' R U R' U' R' F R",
    ],
  ),
  AlgorithmCase(
    id: "t",
    name: "T",
    group: "All",
    cubeStickers: "gyoyyrboygrb",
    algorithms: [
      "R U R' U' R' F R F'",
      "U R U R' U' F' U' F",
      "y2 x U' L' U R' U' L U R",
      "x L U R' U' L' U R U'",
    ],
  ),
  AlgorithmCase(
    id: "h",
    name: "H",
    group: "All",
    cubeStickers: "bgbgyyoryyor",
    algorithms: [
      "R2 U2 R' U2 R2",
      "R2 U2 R U2 R2",
      "F R U R' U' R U R' U' R U R' U' F'",
      "y R U R' U R U' R' U R U2 R'",
    ],
  ),
];
