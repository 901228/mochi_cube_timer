import "package:mochi_cube/nxn.dart";

typedef Vec3 = (int, int, int);

/// Which way each face looks, in [nxnFaceNames] order: x right, y up, z to the front.
const List<Vec3> faceNormals = [(0, 1, 0), (1, 0, 0), (0, 0, 1), (0, -1, 0), (-1, 0, 0), (0, 0, -1)];

int dot(Vec3 a, Vec3 b) => a.$1 * b.$1 + a.$2 * b.$2 + a.$3 * b.$3;

/// [v] a clockwise quarter turn about [axis], as seen from the end it points to: -90 degrees, by Rodrigues'
/// formula, `a (a . v) - a x v`.
Vec3 quarterTurn(Vec3 axis, Vec3 v) {
  final (ax, ay, az) = axis;
  final (x, y, z) = v;
  final d = dot(axis, v);
  return (ax * d - (ay * z - az * y), ay * d - (az * x - ax * z), az * d - (ax * y - ay * x));
}

/// One piece of the cube: where it is, which way it is turned, and where it belongs, which says its colours.
class Cubie {
  Cubie(this.home) : position = home, axes = const [(1, 0, 0), (0, 1, 0), (0, 0, 1)];

  /// Where it is solved, its centre on the grid the cube is built on: two apart, `-size + 1` to `size - 1`.
  final Vec3 home;

  Vec3 position;

  /// Where its own x, y and z point now.
  List<Vec3> axes;

  /// [v], in the piece's own frame, as it now points.
  Vec3 turned(Vec3 v) {
    final [x, y, z] = axes;
    return (
      x.$1 * v.$1 + y.$1 * v.$2 + z.$1 * v.$3,
      x.$2 * v.$1 + y.$2 * v.$2 + z.$2 * v.$3,
      x.$3 * v.$1 + y.$3 * v.$2 + z.$3 * v.$3,
    );
  }
}

/// A cube of [size] turned in the hand: rotations turn it whole, and every move finds it held as the ones
/// before left it, so `R` is always the layer on the right.
class SimulatedCube {
  SimulatedCube(this.size)
    : cubies = [
        for (var x = -size + 1; x < size; x += 2)
          for (var y = -size + 1; y < size; y += 2)
            for (var z = -size + 1; z < size; z += 2)
              // Only the outside shows.
              if ([x, y, z].any((c) => c.abs() == size - 1)) Cubie((x, y, z)),
      ];

  final int size;
  final List<Cubie> cubies;

  /// Whether [cubie] is in the layers [turn] turns.
  bool turns(CubeLayerTurn turn, Cubie cubie) {
    // Layer 1 is the face itself; the centres along the face's normal run down from size - 1, two apart.
    final layer = (size + 1 - dot(faceNormals[turn.face], cubie.position)) ~/ 2;
    return layer >= turn.lo && layer <= turn.hi;
  }

  void turn(CubeLayerTurn turn) {
    final axis = faceNormals[turn.face];
    for (final cubie in cubies.where((c) => turns(turn, c))) {
      for (var q = 0; q < turn.quarters % 4; q++) {
        cubie.position = quarterTurn(axis, cubie.position);
        cubie.axes = [for (final a in cubie.axes) quarterTurn(axis, a)];
      }
    }
  }

  /// [cubie]'s stickers: which way each looks now, and the face it belongs to, by index in [nxnFaceNames].
  Iterable<(Vec3, int)> stickers(Cubie cubie) sync* {
    for (var face = 0; face < 6; face++) {
      if (dot(faceNormals[face], cubie.home) == size - 1) yield (cubie.turned(faceNormals[face]), face);
    }
  }

  /// Whether every face is one colour, whichever way the cube is held.
  bool get isSolved {
    final colours = <Vec3, Set<int>>{};
    for (final cubie in cubies) {
      for (final (normal, face) in stickers(cubie)) {
        (colours[normal] ??= {}).add(face);
      }
    }
    return colours.values.every((faces) => faces.length == 1);
  }
}
