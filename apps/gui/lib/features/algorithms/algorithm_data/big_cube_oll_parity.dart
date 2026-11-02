import "common.dart";

/// OLL parity: flip a single dedge of a 4x4. From SpeedCubeDB.
const List<AlgorithmCase> ollParityCases = [
  AlgorithmCase(
    id: "basic",
    name: "Basic",
    group: "All",
    cubeStickers: "yyyyyyyyyyyyggggbbbborrryyyyrooo",
    algorithms: [
      "Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw'",
      "Rw' U2' Rw U2 Rw U2' Rw2' F2 Rw' U2 Rw' U2' F2 Rw2 F2",
      "Rw2 B2 U2 Lw U2 Rw' U2 Rw U2 F2 Rw F2 Lw' B2 Rw2",
      "Rw2 B2 Rw' U2 Rw' U2 x' U2 Rw' U2 Rw U2 Rw' U2 Rw2 U2 x",
    ],
  ),
  AlgorithmCase(
    id: "pure",
    name: "Pure",
    group: "All",
    cubeStickers: "yyyyyyyyyyyyyggybbbgrooobyygrrro",
    algorithms: [
      "2R' U2 2L F2 2L' F2 2R2 U2 2R U2 2R' U2 F2 2R2 F2",
      "y2 F R U R' U' F' U Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw'",
      "R' U2 Rw' U2 Rw U2 Rw2 U2 x' U2 Rw' U2 Rw U2 l' U2 Rw U2 Rw R",
      "R U2 R' U' Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw' F R' F' R",
    ],
  ),
  AlgorithmCase(
    id: "m",
    name: "M",
    group: "All",
    cubeStickers: "ybbyyyyyyyyygyygbyyborrryggyrooo",
    algorithms: [
      "M Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw' M'",
      "y2 2R2 U2 2R2 Uw2 2R2 Uw2 Rw U2 x Rw U2 Rw U2 Rw' U2 Lw U2 Rw' U2 Rw U2 Rw' U2 Rw'",
      "M Rw2 B2 U2 Lw U2 Rw' U2 Rw U2 F2 Rw F2 Lw' B2 Rw2 M'",
      "M Rw' U2' Rw U2 Rw U2' Rw2' F2 Rw' U2 Rw' U2' F2 Rw2 F2 M'",
    ],
  ),
];
