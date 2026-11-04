/// The moves of [notation] undone: in the opposite order, each turned the other way. Brackets are dropped and
/// the moves spaced out, as [cubeLayerTurns] reads them. Moves are not checked, so one that cannot be read
/// stays as it was.
String invertNotation(String notation) {
  final tokens = notation.split(RegExp(r"[\s()\[\]]+")).where((t) => t.isNotEmpty);
  return tokens.toList().reversed.map(_invert).join(" ");
}

String _invert(String token) {
  if (token.contains("'")) return token.replaceFirst("'", "");
  // The turn and its depth or width, then the count: the prime goes between them.
  final m = RegExp(r"^(\d*[A-Za-z]w?)(\d*)$").firstMatch(token);
  return m == null ? token : "${m[1]}'${m[2]}";
}

/// How the cube is held, as the rotation that holds it so from white (U) on top and green (F) in front, and the
/// faces that end up on top and in front.
typedef Orientation = ({String rotation, String top, String front});

const orientations = <Orientation>[
  (rotation: "", top: "U", front: "F"),
  (rotation: "y", top: "U", front: "R"),
  (rotation: "y2", top: "U", front: "B"),
  (rotation: "y'", top: "U", front: "L"),
  (rotation: "z2", top: "D", front: "F"),
  (rotation: "x2", top: "D", front: "B"),
];

/// [setup] held as [rotation]: the rotation goes first, in the place of [previous], the one put there before,
/// and the rest of the setup stays.
// shortcut: a rotation the user typed over or moved is not recognised, and is left in the setup; the new one
// goes in front of it.
String withOrientation(String setup, {required String previous, required String rotation}) {
  final rest = (previous.isNotEmpty && setup.startsWith(previous) ? setup.substring(previous.length) : setup)
      .trim();
  return [rotation, rest].where((part) => part.isNotEmpty).join(" ");
}
