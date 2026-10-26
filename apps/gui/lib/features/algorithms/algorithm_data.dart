import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";

import "ll_painter.dart";

/// A single algorithm case (e.g. "OLL 1", "Ua") with its diagram and multiple algorithms.
@immutable
class AlgorithmCase {
  const AlgorithmCase({
    required this.id,
    required this.name,
    required this.group,
    required this.algorithms,
    this.ollMask,
    this.pllArrows,
  });

  final String id;
  final String name;
  final String group;

  /// One or more algorithms for this case; the first one is the primary algorithm.
  final List<String> algorithms;

  final int? ollMask;
  final List<PllArrow>? pllArrows;

  Widget buildDiagram({required Color topColor, double arrowStrokeWidth = 12.0}) {
    if (ollMask case final mask?) {
      return CustomPaint(
        painter: OllCasePainter(mask: mask, topColor: topColor),
      );
    }
    if (pllArrows case final arrows?) {
      return CustomPaint(
        painter: PllCasePainter(arrows: arrows, topColor: topColor, strokeWidth: arrowStrokeWidth),
      );
    }
    return const SizedBox.shrink();
  }
}

/// A named collection of [AlgorithmCase]s belonging to a [Puzzle] (e.g. 3x3x3 OLL or PLL).
@immutable
class AlgorithmSet {
  const AlgorithmSet({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.puzzle,
    required this.cases,
  });

  final String id;
  final String name;
  final String subtitle;
  final Puzzle puzzle;
  final List<AlgorithmCase> cases;

  /// Groups in the order they first appear in [cases].
  List<(String group, List<AlgorithmCase> cases)> get grouped {
    final map = <String, List<AlgorithmCase>>{};
    for (final c in cases) {
      (map[c.group] ??= []).add(c);
    }
    return [for (final e in map.entries) (e.key, e.value)];
  }
}

/// Computes the 21-bit OLL sticker mask by inverting the standard [algorithm] on a 3x3x3 cube.
///
/// Supports standard outer turns (`U R F D L B`), wide turns (`Rw Lw Uw Fw Dw Bw` or lowercase
/// `r l u f d b`), slice turns (`M E S`), and cube rotations (`x y z`), ignoring grouping parentheses.
int computeOllMask(String algorithm) {
  final expanded = _expandMoves(algorithm);
  final state = Puzzle.cube3.scrambler.parse(expanded.reversed.map(_invertOuterToken).join(" ")).state;

  // Whatever colour is on the U centre is the U colour (in case the algorithm contains rotations).
  final uFace = state[4];
  var mask = 0;

  void check(int bit, int facelet) {
    if (state[facelet] == uFace) mask |= 1 << bit;
  }

  // U face: 0..8
  for (var i = 0; i < 9; i++) {
    check(i, i);
  }
  // Top (B) bars left-to-right: B2 (47), B1 (46), B0 (45)
  check(9, 47);
  check(10, 46);
  check(11, 45);
  // Right (R) bars top-to-bottom: R2 (11), R1 (10), R0 (9)
  check(12, 11);
  check(13, 10);
  check(14, 9);
  // Bottom (F) bars left-to-right: F0 (18), F1 (19), F2 (20)
  check(15, 18);
  check(16, 19);
  check(17, 20);
  // Left (L) bars top-to-bottom: L0 (36), L1 (37), L2 (38)
  check(18, 36);
  check(19, 37);
  check(20, 38);

  return mask;
}

List<String> _expandMoves(String notation) {
  final tokens = notation
      .replaceAll("(", " ")
      .replaceAll(")", " ")
      .replaceAll("[", " ")
      .replaceAll("]", " ")
      .split(RegExp(r"\s+"))
      .where((s) => s.isNotEmpty)
      .toList();

  // Eliminate rotations/wide moves by tracking which physical face is currently in each position:
  // faces[0..5] = current physical face at [U, R, F, D, L, B].
  var faces = ["U", "R", "F", "D", "L", "B"];
  final result = <String>[];

  // Rotate `faces` as if the whole cube turned 90° CW around the given logical face.
  // Since `faces[i]` is the physical face currently at logical slot `i` ([U, R, F, D, L, B]),
  // rotating the cube moves whatever was at the source slot into the destination slot.
  void rotateCube(String axis, int quarters) {
    for (var q = 0; q < quarters % 4; q++) {
      final [u, r, f, d, l, b] = faces;
      faces = switch (axis) {
        // x (around R): F -> U -> B -> D -> F
        "R" => [f, r, d, b, l, u],
        "L" => [b, r, u, f, l, d],
        // y (around U): R -> F -> L -> B -> R
        "U" => [u, b, r, d, f, l],
        "D" => [u, f, l, d, b, r],
        // z (around F): U -> R -> D -> L -> U
        "F" => [l, u, f, r, d, b],
        "B" => [r, d, f, l, u, b],
        _ => faces,
      };
    }
  }

  String suffixOf(int q) => const ["", "", "2", "'"][q % 4];
  String faceOf(String logical) => faces[const ["U", "R", "F", "D", "L", "B"].indexOf(logical)];

  void emit(String logical, int q) {
    final m = q % 4;
    if (m != 0) result.add("${faceOf(logical)}${suffixOf(m)}");
  }

  for (final token in tokens) {
    final q = token.endsWith("'")
        ? 3
        : token.endsWith("2")
        ? 2
        : 1;
    final base = token.replaceAll("'", "").replaceAll("2", "");
    switch (base) {
      case "U" || "R" || "F" || "D" || "L" || "B":
        emit(base, q);
      case "Uw" || "u":
        emit("D", q);
        rotateCube("U", q);
      case "Rw" || "r":
        emit("L", q);
        rotateCube("R", q);
      case "Fw" || "f":
        emit("B", q);
        rotateCube("F", q);
      case "Dw" || "d":
        emit("U", q);
        rotateCube("D", q);
      case "Lw" || "l":
        emit("R", q);
        rotateCube("L", q);
      case "Bw" || "b":
        emit("F", q);
        rotateCube("B", q);
      case "M":
        // M follows L: L' + R + x'
        emit("L", 4 - q);
        emit("R", q);
        rotateCube("L", q);
      case "E":
        // E follows D: D' + U + y'
        emit("D", 4 - q);
        emit("U", q);
        rotateCube("D", q);
      case "S":
        // S follows F: F' + B + z
        emit("F", 4 - q);
        emit("B", q);
        rotateCube("F", q);
      case "x":
        rotateCube("R", q);
      case "y":
        rotateCube("U", q);
      case "z":
        rotateCube("F", q);
      default:
        throw FormatException("Unsupported move token in OLL algorithm: $token");
    }
  }
  return result;
}

String _invertOuterToken(String token) {
  if (token.endsWith("2")) return token;
  if (token.endsWith("'")) return token.substring(0, token.length - 1);
  return "$token'";
}

AlgorithmCase _oll(int number, String group, List<String> algorithms) => AlgorithmCase(
  id: "oll_$number",
  name: "OLL $number",
  group: group,
  algorithms: algorithms,
  ollMask: computeOllMask(algorithms.first),
);

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

/// All 57 OLL cases grouped by shape, with masks derived directly from their standard algorithms.
final List<AlgorithmCase> ollCases = [
  // All Edges Oriented (7)
  _oll(21, "Cross", [
    "R U2 R' U' R U R' U' R U' R'",
    "R U R' U R U' R' U R U2 R'",
    "F R U R' U' R U R' U' R U R' U' F'",
  ]),
  _oll(22, "Cross", ["R U2 R2 U' R2 U' R2 U2 R", "F R U R' U' F' f R U R' U' f'"]),
  _oll(23, "Cross", ["R2 D R' U2 R D' R' U2 R'", "R2 D' R U2 R' D R U2 R"]),
  _oll(24, "Cross", ["r U R' U' r' F R F'", "L F R' F' L' F R F'"]),
  _oll(25, "Cross", ["F' r U R' U' r' F R", "R' F R B' R' F' R B"]),
  _oll(26, "Cross", ["R U2 R' U' R U' R'", "R' U' R U' R' U2 R"]),
  _oll(27, "Cross", ["R U R' U R U2 R'", "R' U2 R U R' U R"]),

  // Dot (8)
  _oll(1, "Dot", ["R U2 R2 F R F' U2 R' F R F'", "R U B' R B R2 U' R' F R F'"]),
  _oll(2, "Dot", ["r U r' U2 r U2 R' U2 R U' r'", "F R U R' U' F' f R U R' U' f'"]),
  _oll(3, "Dot", ["f R U R' U' f' U' F R U R' U' F'", "r' R2 U R' U r U2 r' U M'"]),
  _oll(4, "Dot", ["f R U R' U' f' U F R U R' U' F'", "M U' r U2 r' U' R U' R' M'"]),
  _oll(17, "Dot", ["R U R' U R' F R F' U2 R' F R F'", "F R' F' R2 r' U R U' R' U' M'"]),
  _oll(18, "Dot", ["r U R' U R U2 r2 U' R U' R' U2 r", "R U2 R2 F R F' U2 M' U R U' r'"]),
  _oll(19, "Dot", ["r' R U R U R' U' M' R' F R F'", "M U R U R' U' M' R' F R F'"]),
  _oll(20, "Dot", ["r U R' U' M2 U R U' R' U' M'", "M U R U R' U' M2 U R U' r'"]),

  // T Shapes (2)
  _oll(33, "T Shapes", ["R U R' U' R' F R F'"]),
  _oll(45, "T Shapes", ["F R U R' U' F'"]),

  // Squares (2)
  _oll(5, "Squares", ["r' U2 R U R' U r", "l' U2 L U L' U l"]),
  _oll(6, "Squares", ["r U2 R' U' R U' r'"]),

  // C Shapes (2)
  _oll(34, "C Shapes", ["R U R2 U' R' F R U R U' F'", "R U R' U' B' R' F R F' B"]),
  _oll(46, "C Shapes", ["R' U' R' F R F' U R"]),

  // W Shapes (2)
  _oll(36, "W Shapes", ["L' U' L U' L' U L U L F' L' F", "R' U' R U' R' U R U R B' R' B"]),
  _oll(38, "W Shapes", ["R U R' U R U' R' U' R' F R F'"]),

  // Corners Correct, Edges Flipped (2)
  _oll(28, "Corners Oriented", ["r U R' U' r' R U R U' R'", "M' U M U2 M' U M"]),
  _oll(57, "Corners Oriented", ["R U R' U' M' U R U' r'"]),

  // P Shapes (4)
  _oll(31, "P Shapes", ["R' U' F U R U' R' F' R"]),
  _oll(32, "P Shapes", ["L U F' U' L' U L F L'", "S R U R' U' R' F R f'"]),
  _oll(43, "P Shapes", ["F' U' L' U L F", "f' L' U' L U f"]),
  _oll(44, "P Shapes", ["F U R U' R' F'", "f R U R' U' f'"]),

  // I Shapes (4)
  _oll(51, "I Shapes", ["f R U R' U' R U R' U' f'", "F U R U' R' U R U' R' F'"]),
  _oll(52, "I Shapes", ["R U R' U R U' B U' B' R'", "R' F' U' F U' R U R' U R"]),
  _oll(55, "I Shapes", ["R' F R U R U' R2 F' R2 U' R' U R U R'", "R U2 R2 U' R U' R' U2 F R F'"]),
  _oll(56, "I Shapes", ["r' U' r U' R' U R U' R' U R r' U r", "f R U R' U' R F' r U R' U' r'"]),

  // Fish Shapes (4)
  _oll(9, "Fish Shapes", ["R U R' U' R' F R2 U R' U' F'"]),
  _oll(10, "Fish Shapes", ["R U R' U R' F R F' R U2 R'"]),
  _oll(35, "Fish Shapes", ["R U2 R2 F R F' R U2 R'"]),
  _oll(37, "Fish Shapes", ["F R' F' R U R U' R'", "F R U' R' U' R U R' F'"]),

  // Knight Move Shapes (4)
  _oll(13, "Knight Move", ["F U R U' R2 F' R U R U' R'", "r U' r' U' r U r' F' U F"]),
  _oll(14, "Knight Move", ["R' F R U R' F' R F U' F'"]),
  _oll(15, "Knight Move", ["l' U' l L' U' L U l' U l", "r' U' r R' U' R U r' U r"]),
  _oll(16, "Knight Move", ["r U r' R U R' U' r U' r'"]),

  // Awkward Shapes (4)
  _oll(29, "Awkward Shapes", ["R U R' U' R U' R' F' U' F R U R'", "M U R U R' U' R' F R F' M'"]),
  _oll(30, "Awkward Shapes", ["F R' F R2 U' R' U' R U R' F2", "F U R U2 R' U' R U2 R' U' F'"]),
  _oll(41, "Awkward Shapes", ["R U R' U R U2 R' F R U R' U' F'"]),
  _oll(42, "Awkward Shapes", ["R' U' R U' R' U2 R F R U R' U' F'"]),

  // L Shapes (6)
  _oll(47, "L Shapes", ["R' U' R' F R F' R' F R F' U R", "F' L' U' L U L' U' L U F"]),
  _oll(48, "L Shapes", ["F R U R' U' R U R' U' F'"]),
  _oll(49, "L Shapes", ["r U' r2 U r2 U r2 U' r", "R B' R2 F R2 B R2 F' R"]),
  _oll(50, "L Shapes", ["r' U r2 U' r2 U' r2 U r'"]),
  _oll(53, "L Shapes", ["l' U2 L U L' U' L U L' U l", "r' U' R U' R' U R U' R' U2 r"]),
  _oll(54, "L Shapes", ["r U2 R' U' R U R' U' R U' r'", "r U R' U R U' R' U R U2 r'"]),

  // Lightning Bolts (6)
  _oll(7, "Lightning Bolts", ["r U R' U R U2 r'"]),
  _oll(8, "Lightning Bolts", ["l' U' L U' L' U2 l", "r' U' R U' R' U2 r"]),
  _oll(11, "Lightning Bolts", ["r U R' U R' F R F' R U2 r'", "r' R2 U R' U R U2 R' U M'"]),
  _oll(12, "Lightning Bolts", ["M' R' U' R U' R' U2 R U' R r'", "F R U R' U' F' U F R U R' U' F'"]),
  _oll(39, "Lightning Bolts", ["L F' L' U' L U F U' L'", "R B' R' U' R U B U' R'"]),
  _oll(40, "Lightning Bolts", ["R' F R U R' U' F' U R"]),
];

/// All built-in algorithm sets, across puzzles.
final List<AlgorithmSet> algorithmSets = [
  AlgorithmSet(
    id: "pll",
    name: "PLL",
    subtitle: "Permutation of the Last Layer",
    puzzle: .cube3,
    cases: pllCases,
  ),
  AlgorithmSet(
    id: "oll",
    name: "OLL",
    subtitle: "Orientation of the Last Layer",
    puzzle: .cube3,
    cases: ollCases,
  ),
];

AlgorithmSet? findAlgorithmSet(String puzzleId, String setId) {
  for (final s in algorithmSets) {
    if (s.puzzle.id == puzzleId && s.id == setId) return s;
  }
  return null;
}

List<AlgorithmSet> algorithmSetsForPuzzle(Puzzle puzzle) =>
    algorithmSets.where((s) => s.puzzle == puzzle).toList();
