import "dart:math" as math;

import "package:flutter/widgets.dart";
import "package:mochi_cube/fto.dart";
import "package:vector_math/vector_math_64.dart";

import "sim_move.dart";
import "simulated_fto.dart";

/// [fto] in perspective, seen from [yaw] round and [pitch] above, with [move] (if any) [progress] of the way
/// through: the layers it turns are drawn turned that far, or the whole puzzle on its way to the new hold, and
/// the puzzle's state is still from before it.
///
/// The octahedron has its vertices one from the centre. A turn cuts it into three layers along two parallel
/// planes, each one convex, so they are drawn far one first, and inside each only the faces facing the eye,
/// which cannot overlap.
class Fto3dPainter extends CustomPainter {
  Fto3dPainter({
    required this.fto,
    required this.colors,
    required this.body,
    required this.yaw,
    required this.pitch,
    this.move,
    this.progress = 0,
    this.startAmount = 0,
    this.hintDistance = 3.0,
    this.puzzleSize = 1.0,
    this.stickerless = false,
    this.hintLabels = true,
    this.isLit,
  });

  final SimulatedFto fto;

  /// The colour of each face, in [ftoFaceNames] order.
  final List<Color> colors;
  final Color body;
  final double yaw;
  final double pitch;
  final SimMove? move;
  final double progress;

  /// Where an [FtoMove] started, in [FtoMove.amount]s from [fto]'s state, when it was changed while turning.
  final double startAmount;

  /// How far past the puzzle the stickers of the faces turned away float, in sixths of its size; 0 leaves them
  /// out.
  final double hintDistance;
  final double puzzleSize;
  final bool stickerless;

  /// Whether the stickers floating behind carry their face's name, on the middle of each face.
  final bool hintLabels;

  /// Whether a sticker, by the facelet it was solved at, is in colour; the others are grey. Null colours them
  /// all.
  final bool Function(int home)? isLit;

  static const _fitDistance = 3.0;
  static const _eye = 5.0;

  /// A third of the way from the centre to a face, on the scale of a unit normal.
  static final _cut = 1 / (3 * math.sqrt(3));

  /// Each sticker's corners and centre, and each face's normal.
  static final _corners = [
    for (var i = 0; i < nFtoFacelets; i++) [for (final c in ftoFaceletCorners(i)) _vector(c) / 3],
  ];
  static final _centres = [for (final c in _corners) (c[0] + c[1] + c[2]) / 3];
  static final _normals = [for (var f = 0; f < 8; f++) ftoNormal(f)];

  /// The facelet in the middle of each face, whose layer a face's name turns with.
  static final _middles = [
    for (var f = 0; f < 8; f++)
      [for (var s = 0; s < 9; s++) f * 9 + s].reduce((a, b) {
        final centre = _normals[f] / math.sqrt(3);
        return (_centres[a] - centre).length < (_centres[b] - centre).length ? a : b;
      }),
  ];

  /// Each face's three corners, the vertices of the octahedron.
  static final _faceCorners = [
    for (final (x, y, z) in ftoFaceNormal)
      [Vector3(x.toDouble(), 0, 0), Vector3(0, y.toDouble(), 0), Vector3(0, 0, z.toDouble())],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    var hold = fto.hold;
    // The axis turning, and each of its three layers' turn.
    int? axis;
    var turnings = List.filled(3, Matrix3.identity());
    switch (move) {
      case FtoHold(:final from, :final to, :final amount):
        hold = amount > 0 ? _slerp(from, to, progress) : _slerp(to, from, progress);
      case final FtoMove m:
        axis = m.face;
        final (a, b, c) = m.base;
        final turned = startAmount + (m.amount - startAmount) * progress;
        turnings = [
          for (final k in [a, b, c])
            Quaternion.axisAngle(_normals[m.face], -2 * math.pi / 3 * k * turned).asRotationMatrix(),
        ];
      case CubeMove() || null:
    }
    final camera = Matrix3.rotationX(pitch).multiplied(Matrix3.rotationY(-yaw)).multiplied(hold);
    final eye = Vector3(0, 0, _eye);

    final scale = puzzleSize * size.shortestSide / ((1 + _fitDistance / 6) * 2 * 1.3);
    final centre = size.center(Offset.zero);
    Offset project(Vector3 p) {
      final k = _eye / (_eye - p.z);
      return centre + Offset(p.x * k * scale, -p.y * k * scale);
    }

    final colours = fto.facelets;
    final homes = fto.stickers.facelets;
    Color colourAt(int i) => isLit == null || isLit!(homes[i]) ? colors[colours[i]] : const Color(0xFF777777);
    int layerOf(int i) => axis == null ? 1 : ftoLayerOf(axis, i);
    Matrix3 viewOf(int layer) => camera.multiplied(turnings[layer]);
    bool facing(Vector3 normal, Vector3 point) => normal.dot(eye - point) > 0;
    Path polygon(List<Vector3> points) => Path()..addPolygon([for (final p in points) project(p)], true);
    List<Vector3> shrunk(List<Vector3> points, double k) {
      final mid = (points[0] + points[1] + points[2]) / 3;
      return [for (final p in points) mid + (p - mid) * k];
    }

    // The stickers of the faces turned away, floating behind the puzzle: one-sided, seen through it.
    final offset = hintDistance / 6;
    // The faces' names, drawn over all the floating stickers, though not over the puzzle.
    final labels = <(String, List<Offset>)>[];
    for (var i = 0; i < nFtoFacelets && offset > 0; i++) {
      final m = viewOf(layerOf(i));
      final normal = m.transformed(_normals[i ~/ 9]);
      final points = [for (final c in _corners[i]) m.transformed(c) + normal * offset];
      if (facing(normal, points[0])) continue;
      canvas.drawPath(polygon(shrunk(points, 0.8)), Paint()..color = colourAt(i));
      if (hintLabels && _middles.contains(i)) {
        final face = [for (final c in _faceCorners[i ~/ 9]) project(m.transformed(c) + normal * offset)];
        labels.add((ftoFaceNames[i ~/ 9], face));
      }
    }

    for (final (name, face) in labels) {
      _label(canvas, name, face);
    }

    final fill = Paint()..color = body;
    // The same colour round the edge too, or antialiasing leaves a hairline of the background between faces.
    final seam = Paint()
      ..color = body
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;

    void drawLayer(int layer) {
      final m = viewOf(layer);
      if (axis != null) {
        // The layer's faces on the cuts: the one towards [axis] and the one towards the opposite face, each
        // looking away from the layer.
        final n = _normals[axis];
        final opposite = ftoOpposite(axis);
        for (final (cut, outward) in switch (layer) {
          0 => [(axis, -n)],
          1 => [(axis, n), (opposite, -n)],
          _ => [(opposite, n)],
        }) {
          final points = [for (final p in _cutPolygon(cut)) m.transformed(p)];
          if (!facing(m.transformed(outward), points[0])) continue;
          canvas
            ..drawPath(polygon(points), fill)
            ..drawPath(polygon(points), seam);
        }
      }
      for (var i = 0; i < nFtoFacelets; i++) {
        if (layerOf(i) != layer) continue;
        final points = [for (final c in _corners[i]) m.transformed(c)];
        if (!facing(m.transformed(_normals[i ~/ 9]), points[0])) continue;
        canvas
          ..drawPath(polygon(points), fill)
          ..drawPath(polygon(points), seam)
          ..drawPath(polygon(shrunk(points, stickerless ? 0.97 : 0.82)), Paint()..color = colourAt(i));
      }
    }

    if (axis == null) {
      drawLayer(1);
    } else {
      // Where the eye is along the axis says which layer is nearest, drawn last.
      final along = camera.transposed().transformed(eye).dot(_normals[axis]);
      final order = along > _cut ? const [2, 1, 0] : (along < -_cut ? const [0, 1, 2] : const [0, 2, 1]);
      order.forEach(drawLayer);
    }
  }

  @override
  bool shouldRepaint(Fto3dPainter old) => true;
}

/// [text] upright on the middle of the face [points], a size to fit its stickers.
void _label(Canvas canvas, String text, List<Offset> points) {
  final side = (points[1] - points[0]).distance;
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontSize: side * (text.length > 1 ? 0.14 : 0.18),
        fontWeight: FontWeight.bold,
        color: const Color(0xFF000000),
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final centre = (points[0] + points[1] + points[2]) / 3;
  painter.paint(canvas, centre - Offset(painter.width, painter.height) / 2);
}

Vector3 _vector((int, int, int) v) => Vector3(v.$1.toDouble(), v.$2.toDouble(), v.$3.toDouble());

/// Where the puzzle is cut a third of the way out towards [face], as a hexagon in order round.
final _cuts = <int, List<Vector3>>{};
List<Vector3> _cutPolygon(int face) => _cuts[face] ??= () {
  final n = _vector(ftoFaceNormal[face]);
  final vertices = [
    for (final v in [(1, 0, 0), (0, 1, 0), (0, 0, 1)]) ...[_vector(v), -_vector(v)],
  ];
  final points = <Vector3>[];
  for (var a = 0; a < 6; a++) {
    for (var b = a + 1; b < 6; b++) {
      // Opposite vertices have no edge between them.
      if ((vertices[a] + vertices[b]).length2 == 0) continue;
      final (pa, pb) = (vertices[a].dot(n) - 1 / 3, vertices[b].dot(n) - 1 / 3);
      if (pa * pb >= 0) continue;
      points.add(vertices[a] + (vertices[b] - vertices[a]) * (pa / (pa - pb)));
    }
  }
  final u = (points[0] - n * (points[0].dot(n) / n.length2))..normalize();
  final w = n.cross(u)..normalize();
  points.sort((p, q) => math.atan2(p.dot(w), p.dot(u)).compareTo(math.atan2(q.dot(w), q.dot(u))));
  return points;
}();

/// [t] of the way from rotation [a] to [b], turning steadily about one axis.
Matrix3 _slerp(Matrix3 a, Matrix3 b, double t) {
  final qa = Quaternion.fromRotation(a);
  var qb = Quaternion.fromRotation(b);
  var d = qa.x * qb.x + qa.y * qb.y + qa.z * qb.z + qa.w * qb.w;
  // The shorter way round.
  if (d < 0) {
    qb = Quaternion(-qb.x, -qb.y, -qb.z, -qb.w);
    d = -d;
  }
  final double wa, wb;
  if (d > 0.9995) {
    (wa, wb) = (1 - t, t);
  } else {
    final theta = math.acos(d);
    (wa, wb) = (math.sin((1 - t) * theta) / math.sin(theta), math.sin(t * theta) / math.sin(theta));
  }
  return Quaternion(
    qa.x * wa + qb.x * wb,
    qa.y * wa + qb.y * wb,
    qa.z * wa + qb.z * wb,
    qa.w * wa + qb.w * wb,
  ).normalized().asRotationMatrix();
}
