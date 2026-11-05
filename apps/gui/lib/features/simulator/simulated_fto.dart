import "package:mochi_cube/fto.dart";
import "package:vector_math/vector_math_64.dart";

import "sim_move.dart";

/// The FTO turned in the hand: its stickers on the puzzle's own faces, as [Fto] has them, and the way it is held.
class SimulatedFto {
  /// Which sticker is at each facelet, by the facelet it was solved at.
  final stickers = Fto.fromFacelets([for (var i = 0; i < nFtoFacelets; i++) i]);

  /// The face each facelet's sticker belongs to, which says its colour.
  List<int> get facelets => [for (final home in stickers.facelets) home ~/ 9];

  /// Takes the puzzle's own frame to the one it is seen in, before the view is dragged round: x right, y up, z
  /// to the front.
  Matrix3 hold = ftoHold(0, 2);

  void turn(SimMove move) {
    switch (move) {
      case FtoMove(:final face, layers: (final a, final b, final c)):
        // The middle layer is the whole puzzle turned; the outer two turn on from there.
        stickers
          ..turn(face, (a - b) % 3)
          ..turn(ftoOpposite(face), (b - c) % 3);
        hold = hold.multiplied(ftoWholeTurn(face, b));
      case FtoHold(:final from, :final to, :final amount):
        hold = (amount > 0 ? to : from).clone();
      case CubeMove():
        throw ArgumentError.value(move, "move", "is not an FTO move");
    }
  }
}

/// What a sticker of the FTO is on, by its slot on its face.
enum FtoPiece { corner, edge, centre }

FtoPiece ftoPieceOf(int facelet) => switch (facelet % 9) {
  1 || 4 || 8 => FtoPiece.corner,
  3 || 6 || 7 => FtoPiece.edge,
  _ => FtoPiece.centre,
};

/// Which of the three layers of [face]'s axis [facelet] is in: 0 the one at [face], 1 the middle, 2 the far one.
int ftoLayerOf(int face, int facelet) {
  final (x, y, z) = ftoFaceletCorners(facelet)
      .fold((0, 0, 0), (s, c) => (s.$1 + c.$1, s.$2 + c.$2, s.$3 + c.$3));
  final (s1, s2, s3) = ftoFaceNormal[face];
  // Nine times the centre, so the cuts a third of the way out are at 3.
  final d = s1 * x + s2 * y + s3 * z;
  return d > 3 ? 0 : (d < -3 ? 2 : 1);
}

Vector3 _vector((int, int, int) v) => Vector3(v.$1.toDouble(), v.$2.toDouble(), v.$3.toDouble());

/// Which way [face] looks, of length 1.
Vector3 ftoNormal(int face) => _vector(ftoFaceNormal[face])..normalize();

int ftoOpposite(int face) {
  final (x, y, z) = ftoFaceNormal[face];
  return ftoFaceNormal.indexOf((-x, -y, -z));
}

/// The puzzle held with [up] on top and [front] facing the eye: a corner in front when they share one, an edge
/// when they share an edge.
Matrix3 ftoHold(int up, int front) {
  final y = ftoNormal(up);
  final f = ftoNormal(front);
  final z = (f - y * f.dot(y))..normalize();
  final x = y.cross(z);
  // Rows x, y and z, given a column at a time.
  return Matrix3(x.x, y.x, z.x, x.y, y.y, z.y, x.z, y.z, z.z);
}

/// The whole puzzle turned [thirds] of a turn clockwise about [face], in the puzzle's own frame.
Matrix3 ftoWholeTurn(int face, int thirds) {
  final once = Matrix3.columns(
    _vector(ftoTurned(face, (1, 0, 0))),
    _vector(ftoTurned(face, (0, 1, 0))),
    _vector(ftoTurned(face, (0, 0, 1))),
  );
  final turned = Matrix3.identity();
  for (var t = 0; t < thirds % 3; t++) {
    turned.multiply(once);
  }
  return turned;
}
