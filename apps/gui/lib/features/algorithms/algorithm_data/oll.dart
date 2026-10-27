import "package:cube_timer/cube_timer.dart";

import "common.dart";

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

AlgorithmCase _oll(int number, String group, List<String> algorithms) => AlgorithmCase(
  id: "oll_$number",
  name: "OLL $number",
  group: group,
  algorithms: algorithms,
  ollMask: computeOllMask(algorithms.first),
);

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
