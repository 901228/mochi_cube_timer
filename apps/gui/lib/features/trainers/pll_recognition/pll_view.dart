import "package:mochi_cube/nxn.dart";

/// Where the faces start in [NxNCube.facelets].
const _right = 1 * 9;
const _front = 2 * 9;
const _left = 4 * 9;
const _back = 5 * 9;

/// One move of the notation, as a face index of [nxnFaceNames], how many layers it turns, and how many
/// quarter turns clockwise.
typedef _Turn = ({int face, int width, int quarters});

/// The turns a token such as `R'`, `Uw2`, `M` or `y` makes. The slices turn with the face they follow:
/// M with L, E with D, S with F.
List<_Turn> _turns(String token, {required bool inverse}) {
  final match = RegExp(r"^([URFDLBurfdlbMESxyz])(w)?(2'?|')?$").firstMatch(token);
  if (match == null) throw FormatException("Not a move: $token");

  final base = match[1]!;
  final wide = match[2] != null || "urfdlb".contains(base);
  var quarters = switch (match[3]) {
    null => 1,
    "'" => 3,
    _ => 2,
  };
  if (inverse) quarters = 4 - quarters;

  _Turn turn(int face, int width, int q) => (face: face, width: width, quarters: q);
  int face(String s) => "URFDLB".indexOf(s);

  return switch (base) {
    "M" => [turn(face("L"), 2, quarters), turn(face("L"), 1, 4 - quarters)],
    "E" => [turn(face("D"), 2, quarters), turn(face("D"), 1, 4 - quarters)],
    "S" => [turn(face("F"), 2, quarters), turn(face("F"), 1, 4 - quarters)],
    "x" => [turn(face("R"), 3, quarters)],
    "y" => [turn(face("U"), 3, quarters)],
    "z" => [turn(face("F"), 3, quarters)],
    _ => [turn(face(base.toUpperCase()), wide ? 2 : 1, quarters)],
  };
}

/// The top rows of the front and the right side of the case [algorithm] solves, as the faces the six
/// stickers belong to (indices of [nxnFaceNames]): the front's from left to right, then the right's
/// from front to back.
///
/// The case is what the algorithm undoes, so it is made by running the algorithm backwards from a
/// solved cube. A case is the same case whichever way the top layer is turned before and after it, so
/// [preAuf] turns the layer that many quarters before the case is made and [auf] that many after, and
/// [rotation] holds the cube that many quarter turns about the vertical axis, which is what gives a
/// case its four colour combinations.
List<int> pllTwoSide(String algorithm, {int preAuf = 0, int auf = 0, int rotation = 0}) =>
    pllLook(algorithm, preAuf: preAuf, auf: auf, rotation: rotation).strip;

/// The top rows of a look: the two sides in view as [pllTwoSide] gives them, and the other two, read
/// as the strip goes on round the cube: `left` runs on to the left of the strip's start, ending at the
/// front, and `back` on from the strip's end.
typedef PllLook = ({List<int> strip, List<int> left, List<int> back});

PllLook pllLook(String algorithm, {int preAuf = 0, int auf = 0, int rotation = 0}) {
  final cube = NxNCube(3)..turn(0, 1, preAuf);
  final tokens = algorithm.replaceAll(RegExp(r"[()]"), " ").split(RegExp(r"\s+")).where((t) => t.isNotEmpty);
  for (final token in tokens.toList().reversed) {
    for (final t in _turns(token, inverse: true)) {
      cube.turn(t.face, t.width, t.quarters);
    }
  }

  // An algorithm with a slice or a rotation in it may leave the cube held another way round.
  for (var i = 0; i < 4 && cube.facelets[_front + 4] != 2; i++) {
    cube.turn(0, 3);
  }

  cube.turn(0, 3, rotation);
  cube.turn(0, 1, auf);
  List<int> row(int face) => [for (var i = 0; i < 3; i++) cube.facelets[face + i]];
  return (strip: [...row(_front), ...row(_right)], left: row(_left), back: row(_back));
}
