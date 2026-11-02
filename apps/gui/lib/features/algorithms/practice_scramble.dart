import "dart:math";

import "algorithm_data/common.dart";

const _faces = "URFDLB";

/// Where each face's stickers go on a clockwise quarter turn of that face: `U` takes F's to L, and so on.
const _cycles = {"U": "FLBR", "R": "UBDF", "F": "URDL", "D": "FRBL", "L": "UFDB", "B": "ULDR"};

String _opposite(String face) => _faces[(_faces.indexOf(face) + 3) % 6];

final _token = RegExp(r"^(\d+)?([URFDLBurfdlbMESxyz])(w?)(2'?|')?$");

/// A turn of the outer block [width] layers deep, in the notation of the timer's NxN scramblers.
typedef _Turn = ({String face, int width, int quarters});

/// [alg], written for a cube of [size] with any rotations, slices and wide turns, as the face and wide turns
/// that do the same to a cube held still, so a scrambler can read them; and which face of that cube each
/// face is held as at the end.
(List<_Turn>, Map<String, String>) _outerTurns(String alg, int size) {
  // The face each face of the cube as it is now held was, when the algorithm started.
  final held = {for (final f in _faces.split("")) f: f};
  final turns = <_Turn>[];

  void rotate(String face, int quarters) {
    final cycle = _cycles[face]!;
    for (var i = 0; i < quarters % 4; i++) {
      final before = Map.of(held);
      for (var j = 0; j < 4; j++) {
        held[cycle[(j + 1) % 4]] = before[cycle[j]]!;
      }
    }
  }

  void block(String face, int width, int quarters) {
    if (quarters % 4 != 0) turns.add((face: held[face]!, width: width, quarters: quarters % 4));
  }

  // Layers lo to hi of [face], counted from it, turned [quarters] clockwise as seen from it.
  void layers(String face, int lo, int hi, int quarters) {
    if (lo == 1 && hi == size) return rotate(face, quarters);
    if (hi == size) return layers(_opposite(face), 1, size - lo + 1, -quarters);
    if (lo > 1) {
      layers(face, 1, hi, quarters);
      return layers(face, 1, lo - 1, -quarters);
    }
    if (hi <= size ~/ 2) return block(face, hi, quarters);
    // Deeper than a scrambler turns: the whole cube, less the rest from the other side.
    rotate(face, quarters);
    block(_opposite(face), size - hi, quarters);
  }

  for (final token in alg.replaceAll(RegExp(r"[()\[\]]"), " ").split(RegExp(r"\s+"))) {
    if (token.isEmpty) continue;
    final m = _token.firstMatch(token);
    if (m == null) throw FormatException("unsupported move", token);
    final quarters = switch (m[4]) {
      null => 1,
      "'" => 3,
      _ => 2,
    };
    final name = m[2]!;
    final depth = m[1] == null ? null : int.parse(m[1]!);
    // M, E and S: every inner layer of an even cube, the middle one of an odd cube.
    final (inLo, inHi) = size.isEven ? (2, size - 1) : ((size + 1) ~/ 2, (size + 1) ~/ 2);
    switch (name) {
      case "x" || "y" || "z":
        if (depth != null || m[3]!.isNotEmpty) throw FormatException("unsupported move", token);
        rotate({"x": "R", "y": "U", "z": "F"}[name]!, quarters);
      case "M" || "E" || "S":
        if (depth != null || m[3]!.isNotEmpty || size < 3) throw FormatException("unsupported move", token);
        layers({"M": "L", "E": "D", "S": "F"}[name]!, inLo, inHi, quarters);
      default:
        final face = name.toUpperCase();
        final wide = m[3]!.isNotEmpty || name != face;
        final (lo, hi) = wide ? (1, depth ?? 2) : (depth ?? 1, depth ?? 1);
        if (hi > size || (wide && name != face && depth != null)) {
          throw FormatException("unsupported move", token);
        }
        layers(face, lo, hi, quarters);
    }
  }
  return (turns, held);
}

/// [faces] after the whole cube turns [quarters] about [axis]: each face's stickers, and where they are.
Map<String, String> _turnedRound(Map<String, String> faces, String axis, int quarters) {
  final cycle = _cycles[axis]!;
  String next(String f) => cycle.contains(f) ? cycle[(cycle.indexOf(f) + quarters) % 4] : f;
  return {for (final e in faces.entries) e.key: next(e.value)};
}

/// Turns of the whole cube that take each face's stickers to the face [held] says.
List<_Turn> _turnRound(Map<String, String> held) {
  final start = {for (final f in _faces.split("")) f: f};
  final queue = [(start, <_Turn>[])];
  for (var i = 0; i < queue.length; i++) {
    final (faces, path) = queue[i];
    if (_faces.split("").every((f) => faces[f] == held[f])) return path;
    if (path.length == 2) continue;
    for (final axis in ["R", "U", "F"]) {
      for (var q = 1; q < 4; q++) {
        queue.add((_turnedRound(faces, axis, q), [...path, (face: axis, width: 0, quarters: q)]));
      }
    }
  }
  throw StateError("no turn of the cube gives $held");
}

/// [turns] with each run of turns of one block merged, and any that come to nothing left out.
List<_Turn> _merged(Iterable<_Turn> turns) {
  final out = <_Turn>[];
  for (final t in turns) {
    if (out.isNotEmpty && out.last.face == t.face && out.last.width == t.width) {
      final q = (out.removeLast().quarters + t.quarters) % 4;
      if (q != 0) out.add((face: t.face, width: t.width, quarters: q));
    } else {
      out.add(t);
    }
  }
  return out;
}

String _render(_Turn t) =>
    "${t.width > 2 ? t.width : ""}${t.face}${t.width > 1 ? "w" : ""}${const ["", "", "2", "'"][t.quarters]}";

/// The puzzles the practice scrambles are made for, by the size of the cube.
int? practiceCubeSize(String puzzleId) => switch (puzzleId) {
  "222" => 2,
  "333" => 3,
  "444" => 4,
  "555" => 5,
  "666" => 6,
  "777" => 7,
  _ => null,
};

/// A scramble that leaves the cube of [size] (solved but for the case) where [item]'s first algorithm that can
/// be read solves it: the algorithm undone. With [auf], a random turn of U before and after, so a last-layer
/// case comes up at any angle.
String practiceScramble(AlgorithmCase item, int size, {bool auf = false, Random? random}) {
  random ??= Random();
  FormatException? error;
  for (final alg in item.algorithms) {
    try {
      final (turns, held) = _outerTurns(alg, size);
      final undo = [for (final t in turns.reversed) (face: t.face, width: t.width, quarters: 4 - t.quarters)];
      // An even cube has no centres to hold it by, so the algorithm decides which way round its colours end
      // up; they are turned round first, as two halves, for it to end the right way up.
      final colours = [
        if (size.isEven)
          for (final r in _turnRound(held)) ...[
            (face: r.face, width: size ~/ 2, quarters: r.quarters),
            (face: _opposite(r.face), width: size ~/ 2, quarters: 4 - r.quarters),
          ],
      ];
      _Turn u() => (face: "U", width: 1, quarters: random!.nextInt(4));
      return _merged([if (auf) u(), ...colours, ...undo, if (auf) u()])
          .where((t) => t.quarters != 0)
          .map(_render)
          .join(" ");
    } on FormatException catch (e) {
      error = e;
    }
  }
  throw error ?? FormatException("no algorithm", item.id);
}

/// The practice of 3x3's cross: no cases to pick from, so it is not an algorithm set; it has the ordinary
/// scrambles, and its solves are kept apart from the puzzle's own under this id.
const crossDrillId = "cross";
