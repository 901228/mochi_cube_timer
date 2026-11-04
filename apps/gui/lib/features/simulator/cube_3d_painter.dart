import "dart:math" as math;

import "package:flutter/widgets.dart";
import "package:mochi_cube/nxn.dart";
import "package:vector_math/vector_math_64.dart";

import "simulated_cube.dart";

/// [cube] in perspective, seen from [yaw] round and [pitch] above, with [turn] (if any) [progress] of the way
/// through: the layers it turns are drawn turned that far, and the cube's state is still from before it.
///
/// Only faces turned towards the eye are drawn. The cube is cut into the layers turning and the ones either
/// side, each a convex block, drawn far one first; inside a block the faces facing the eye cannot overlap.
/// The stickers of the faces turned away are drawn again floating behind the cube.
class Cube3dPainter extends CustomPainter {
  Cube3dPainter({
    required this.cube,
    required this.colors,
    required this.body,
    required this.yaw,
    required this.pitch,
    this.turn,
    this.progress = 0,
    this.hintDistance = 3.0,
    this.cubeSize = 1.0,
    this.stickerless = false,
    this.hintLabels = true,
    this.isLit,
  });

  final SimulatedCube cube;

  /// The colour of each face, in [nxnFaceNames] order.
  final List<Color> colors;

  /// The plastic between the stickers.
  final Color body;
  final double yaw;
  final double pitch;
  final CubeLayerTurn? turn;
  final double progress;

  /// How far past the cube the stickers of the faces turned away float, in half cubies; 0 leaves them out.
  final double hintDistance;

  /// The cube's size as a multiple of what fits the view with the hints at their usual distance.
  final double cubeSize;

  static const _fitDistance = 3.0;

  /// Whether the middle hint sticker of each face turned away carries the face's letter.
  final bool hintLabels;

  /// Whether a sticker is in colour, given the home of its piece and the face it was solved on; the others
  /// are dimmed. Null colours them all.
  final bool Function(Vec3 home, int face)? isLit;

  /// Each face all its colour, rather than stickers on black plastic.
  final bool stickerless;

  @override
  void paint(Canvas canvas, Size size) {
    final n = cube.size;
    final camera = Matrix3.rotationX(pitch) * Matrix3.rotationY(-yaw) as Matrix3;
    final turn = this.turn;
    final axis = turn == null ? null : faceNormals[turn.face];
    final turning = turn == null
        // Clockwise seen from the face is negative about its normal.
        ? Matrix3.identity()
        : Quaternion.axisAngle(_vector(axis!), -math.pi / 2 * turn.quarters * progress).asRotationMatrix();

    final distance = n * 5.0;
    // Room for the hints at their usual distance and a little past it; moving them leaves the cube's size alone.
    final scale = cubeSize * size.shortestSide / ((n + _fitDistance) * 2 * 1.5);
    final centre = size.center(Offset.zero);
    Offset project(Vector3 p) {
      final k = distance / (distance - p.z);
      return centre + Offset(p.x * k * scale, -p.y * k * scale);
    }

    // Which block a position is in: 0 the layers before the turning ones, 1 those turning, 2 after.
    int block(Vec3 p) {
      if (turn == null) return 1;
      final layer = (n + 1 - dot(axis!, p)) ~/ 2;
      return layer < turn.lo ? 0 : (layer > turn.hi ? 2 : 1);
    }

    bool inside(Vec3 p) => p.$1.abs() < n && p.$2.abs() < n && p.$3.abs() < n;

    // The corners of the face of [cubie] turned to [normal], [inset] of the way in from its edges, [lift] out.
    // And whether it faces the eye.
    (List<Offset>, bool) quad(Cubie cubie, Vec3 normal, Matrix3 rotation, double inset, double lift) {
      final (u, v) = _edges(normal);
      final base = _vector(cubie.position) + _vector(normal) * (1 + lift);
      List<Offset> corners(double k) => [
        for (final (a, b) in const [(1.0, 1.0), (-1.0, 1.0), (-1.0, -1.0), (1.0, -1.0)])
          project(camera * (rotation * (base + (_vector(u) * a + _vector(v) * b) * k))),
      ];
      // Its winding on the screen says which way it faces.
      final surface = corners(1);
      final e1 = surface[1] - surface[0];
      final e2 = surface[2] - surface[1];
      final cross = e1.dx * e2.dy - e1.dy * e2.dx;
      final (cx, cy, cz) = _cross(u, v);
      final handed = (cx * normal.$1 + cy * normal.$2 + cz * normal.$3) > 0 ? 1 : -1;
      // Screen y points down, so a face turned to the eye winds the other way from the usual.
      final front = cross * handed < 0;
      return (corners(inset), front);
    }

    Path polygon(List<Offset> points) => Path()..addPolygon(points, true);

    Matrix3 rotationOf(Cubie c) => turn != null && block(c.position) == 1 ? turning : Matrix3.identity();

    // The stickers of the faces turned away, floating behind the cube.
    for (final c in hintDistance > 0 ? cube.cubies : const <Cubie>[]) {
      for (final (normal, face) in cube.stickers(c)) {
        // One-sided like a sticker, facing the cube: seen only from behind it, through the cube.
        final (points, front) = quad(c, normal, rotationOf(c), 0.62, hintDistance);
        if (front) continue;
        canvas.drawPath(polygon(points), Paint()..color = _colour(c, face));
        // The middle sticker of a face: no other coordinate of its cubie off the centre.
        if (hintLabels && [c.home.$1, c.home.$2, c.home.$3].where((v) => v.abs() > 1).length == 1) {
          _label(canvas, nxnFaceNames[face], points, _colour(c, face));
        }
      }
    }

    // Where the eye is along the turning axis says which side of the turning layers is nearer.
    var order = const [1];
    if (turn != null) {
      final eye = camera.transposed() * Vector3(0, 0, distance);
      final along = eye.dot(_vector(axis!));
      final top = n + 2 - 2 * turn.lo;
      final bottom = n - 2 * turn.hi;
      order = along > top ? const [2, 1, 0] : (along < bottom ? const [0, 1, 2] : const [0, 2, 1]);
    }

    final fill = Paint()..color = body;
    // The same colour round the edge too, or the antialiased edges of two faces side by side leave a hairline of the
    // background between them.
    final seam = Paint()
      ..color = body
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    for (final b in order) {
      for (final c in cube.cubies) {
        if (block(c.position) != b) continue;
        final stickers = {for (final (normal, face) in cube.stickers(c)) normal: face};
        for (final normal in faceNormals) {
          final next = (
            c.position.$1 + 2 * normal.$1,
            c.position.$2 + 2 * normal.$2,
            c.position.$3 + 2 * normal.$3,
          );
          // A face against another piece of its own block is inside it.
          if (inside(next) && block(next) == b) continue;
          final body = quad(c, normal, rotationOf(c), 1, 0);
          if (!body.$2) continue;
          canvas.drawPath(polygon(body.$1), fill);
          canvas.drawPath(polygon(body.$1), seam);
          final face = stickers[normal];
          if (face != null) {
            canvas.drawPath(
              polygon(quad(c, normal, rotationOf(c), stickerless ? 0.95 : 0.84, 0).$1),
              Paint()..color = _colour(c, face),
            );
          }
        }
      }
    }
  }

  /// The colour of [face]'s sticker on [cubie], dimmed when [isLit] says it is not one to look at.
  Color _colour(Cubie cubie, int face) {
    final colour = colors[face];
    return isLit == null || isLit!(cubie.home, face)
        ? colour
        : Color.lerp(colour, const Color(0xFF8A8A8A), 0.8)!;
  }

  @override
  bool shouldRepaint(Cube3dPainter old) => true;
}

/// [text] upright on the middle of the quad [points], as large as the quad's side allows.
void _label(Canvas canvas, String text, List<Offset> points, Color background) {
  final side = (points[1] - points[0]).distance;
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontSize: side * 0.7,
        fontWeight: FontWeight.bold,
        color: background.computeLuminance() > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final centre = (points[0] + points[2]) / 2;
  painter.paint(canvas, centre - Offset(painter.width, painter.height) / 2);
}

Vector3 _vector(Vec3 v) => Vector3(v.$1.toDouble(), v.$2.toDouble(), v.$3.toDouble());

Vec3 _cross(Vec3 a, Vec3 b) =>
    (a.$2 * b.$3 - a.$3 * b.$2, a.$3 * b.$1 - a.$1 * b.$3, a.$1 * b.$2 - a.$2 * b.$1);

(Vec3, Vec3) _edges(Vec3 normal) => switch (normal) {
  (0, _, 0) => ((1, 0, 0), (0, 0, 1)),
  (_, 0, 0) => ((0, 1, 0), (0, 0, 1)),
  _ => ((1, 0, 0), (0, 1, 0)),
};
