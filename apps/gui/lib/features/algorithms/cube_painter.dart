import "dart:math" as math;

import "package:flutter/widgets.dart";

import "../../database/dao_provider.dart";
import "../../shared/utils.dart";

/// The last layer of an NxN cube seen from above, solved with its D face on top (as after `z2`).
///
/// [stickers] is the U face row by row, then the row of each side next to it as seen from above:
/// B left to right, R top to bottom, F left to right, L top to bottom (`n * n + 4 * n` letters).
/// Letters name the face a sticker belongs to on the solved cube held that way: `y` the top
/// (the D face), `w` U, `g` F, `b` B, `o` the right side (the L face), `r` the left side (the R face);
/// anything else is a sticker that does not matter.
class CubeCaseDiagram extends StatelessWidget {
  const CubeCaseDiagram({super.key, required this.stickers});

  final String stickers;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CubeCasePainter(stickers: stickers, colors: _colors(context)),
    );
  }
}

/// The colours of [CubeCaseDiagram]'s letters, from the user's cube colour settings.
Map<String, Color> _colors(BuildContext context) {
  final settings = SettingsProvider.of(context);
  return {
    "y": settings.cubeColorD.toColor(),
    "w": settings.cubeColorU.toColor(),
    "g": settings.cubeColorF.toColor(),
    "b": settings.cubeColorB.toColor(),
    "o": settings.cubeColorL.toColor(),
    "r": settings.cubeColorR.toColor(),
  };
}

/// An NxN cube seen from above its front-right corner, held as for [CubeCaseDiagram].
///
/// [stickers] is three faces of `n * n` letters, each row by row as seen from outside with the top up:
/// U (back row first), F, then R (its left column is the one next to F). Letters as for [CubeCaseDiagram].
class CubeIsoDiagram extends StatelessWidget {
  const CubeIsoDiagram({super.key, required this.stickers});

  final String stickers;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CubeIsoPainter(stickers: stickers, colors: _colors(context)),
    );
  }
}

int _sizeOfFaces(String stickers, int faces, String what) {
  final n = math.sqrt(stickers.length / faces).round();
  if (n < 2 || faces * n * n != stickers.length) {
    throw ArgumentError.value(stickers, "stickers", "is not an NxN $what");
  }
  return n;
}

/// The side length of the cube [stickers] describe, from `3 * n * n` letters.
int cubeIsoStickersSize(String stickers) => _sizeOfFaces(stickers, 3, "corner view");

/// The side length of the cube [stickers] describe, from `2 * n * n` letters.
int cubeFaceStickersSize(String stickers) => _sizeOfFaces(stickers, 2, "pair of faces");

/// Two faces of an NxN cube, U above F as they are while turning, for cases that only touch those (such as the last two centers).
///
/// [stickers] is the U face and then the F face, each `n * n` letters row by row as seen from outside with
/// the top up. Letters as for [CubeCaseDiagram].
class CubeFacesDiagram extends StatelessWidget {
  const CubeFacesDiagram({super.key, required this.stickers});

  final String stickers;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CubeFacesPainter(stickers: stickers, colors: _colors(context)),
    );
  }
}

/// The side length of the cube [stickers] describe, from `n * n + 4 * n` letters.
int cubeStickersSize(String stickers) {
  final n = (math.sqrt(4 + stickers.length) - 2).round();
  if (n < 2 || n * n + 4 * n != stickers.length) {
    throw ArgumentError.value(stickers, "stickers", "is not an NxN top view");
  }
  return n;
}

// A 569-unit square. Everything is sized from the sticker, so the corners and edges of a big cube look
// like those of a small one: a side bar is two thirds of a sticker deep, and the gap between stickers
// is what the OLL diagram uses.
const _extent = 569.0;
const _gap = 23.0 / 139.0;
const _barDepth = 2.0 / 3.0;
const _unknownColor = Color(0xFF777777);

void _drawSticker(Canvas canvas, Rect rect, double radius, double stroke, Color fill) {
  canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)), Paint()..color = fill);
  canvas.drawRRect(
    RRect.fromRectAndRadius(rect.deflate(stroke / 2), Radius.circular(radius - stroke / 2)),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = _unknownColor,
  );
}

class CubeCasePainter extends CustomPainter {
  CubeCasePainter({required this.stickers, required this.colors}) : n = cubeStickersSize(stickers);

  final String stickers;
  final Map<String, Color> colors;
  final int n;

  @override
  void paint(Canvas canvas, Size size) {
    final span = n + (n - 1) * _gap + 2 * (_barDepth + _gap); // in stickers
    final cell = _extent / span;
    final scale = math.min(size.width, size.height) / _extent;
    canvas.save();
    canvas.translate((size.width - _extent * scale) / 2, (size.height - _extent * scale) / 2);
    canvas.scale(scale);

    final bar = cell * _barDepth;
    final first = bar + cell * _gap;
    final step = cell * (1 + _gap);
    final far = _extent - bar;
    // The same fraction of the short side everywhere, so a bar is as round as a sticker.
    final radius = cell / 4;
    final barRadius = bar / 4;
    final stroke = cell * 6 / 139;
    double start(int i) => first + i * step;
    Color color(int i) => colors[stickers[i]] ?? _unknownColor;

    void draw(Rect rect, double radius, Color fill) => _drawSticker(canvas, rect, radius, stroke, fill);

    for (var i = 0; i < n * n; i++) {
      draw(Rect.fromLTWH(start(i % n), start(i ~/ n), cell, cell), radius, color(i));
    }
    final side = n * n;
    for (var i = 0; i < n; i++) {
      draw(Rect.fromLTWH(start(i), 0, cell, bar), barRadius, color(side + i));
      draw(Rect.fromLTWH(far, start(i), bar, cell), barRadius, color(side + n + i));
      draw(Rect.fromLTWH(start(i), far, cell, bar), barRadius, color(side + 2 * n + i));
      draw(Rect.fromLTWH(0, start(i), bar, cell), barRadius, color(side + 3 * n + i));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CubeCasePainter old) => old.stickers != stickers || !_sameColors(old.colors, colors);

  static bool _sameColors(Map<String, Color> a, Map<String, Color> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);
}

const _bodyColor = Color(0xFF222222);

// Lengths of [CubeIsoPainter], in stickers (an edge of the cube is as long as it has stickers, in any direction).
/// How much of its cell a sticker covers, and how far from each corner its sides start to curve.
const _isoInset = 0.86;
const _isoCut = 0.25 * _isoInset;

/// The gap between the outer edge of a sticker and the edge of the body, square to both.
const _bodyMargin = (1 - _isoInset) / 2 * 0.8660254;

/// The body's corner radius: a sticker's, plus the margin, so the body's edge keeps its distance from the
/// stickers' as it turns the corner (a sticker's corner is as round as a circle of `cut * tan(60 degrees)`).
final _bodyRadius = _isoCut * math.sqrt(3) + _bodyMargin;

/// The hexagon [pts] (clockwise on the screen, every corner 120 degrees) with its corners rounded to [radius].
Path _roundedHexagon(List<Offset> pts, double radius) {
  final path = Path();
  final tangent = radius / math.sqrt(3); // from a corner to where the arc starts
  for (var i = 0; i < pts.length; i++) {
    final v = pts[i];
    Offset towards(Offset p) => v + (p - v) / (p - v).distance * tangent;
    final from = towards(pts[(i - 1) % pts.length]);
    final to = towards(pts[(i + 1) % pts.length]);
    i == 0 ? path.moveTo(from.dx, from.dy) : path.lineTo(from.dx, from.dy);
    path.arcToPoint(to, radius: Radius.circular(radius));
  }
  return path..close();
}

/// [pts] as a closed path whose corners are cut [cut] short and joined by a curve.
Path _roundedPolygon(List<Offset> pts, double cut) {
  final path = Path();
  for (var i = 0; i < pts.length; i++) {
    final v = pts[i];
    Offset towards(Offset p) {
      final d = p - v;
      return v + d / d.distance * math.min(cut, d.distance / 2);
    }

    final from = towards(pts[(i - 1) % pts.length]);
    final to = towards(pts[(i + 1) % pts.length]);
    i == 0 ? path.moveTo(from.dx, from.dy) : path.lineTo(from.dx, from.dy);
    path.quadraticBezierTo(v.dx, v.dy, to.dx, to.dy);
  }
  return path..close();
}

class CubeIsoPainter extends CustomPainter {
  CubeIsoPainter({required this.stickers, required this.colors}) : n = cubeIsoStickersSize(stickers);

  final String stickers;
  final Map<String, Color> colors;
  final int n;

  @override
  void paint(Canvas canvas, Size size) {
    // x to the right and back, z to the left and front, y up; the cube spans 0..n on each.
    final cos30 = math.sqrt(3) / 2;
    Offset at(num x, num y, num z) => Offset((x - z) * cos30, (x + z) / 2 - y);

    final unit = math.min(size.width / (2 * n * cos30), size.height / (2 * n));
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(unit);

    final body = [at(0, n, 0), at(n, n, 0), at(n, 0, 0), at(n, 0, n), at(0, 0, n), at(0, n, n)];
    canvas.drawPath(_roundedHexagon(body, _bodyRadius), Paint()..color = _bodyColor);

    void sticker(List<Offset> corners, String letter) {
      final centre = corners.reduce((a, b) => a + b) / corners.length.toDouble();
      final pts = [for (final p in corners) centre + (p - centre) * _isoInset];
      canvas.drawPath(_roundedPolygon(pts, _isoCut), Paint()..color = colors[letter] ?? _unknownColor);
    }

    final face = n * n;
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final i = r * n + c;
        sticker([at(c, n, r), at(c + 1, n, r), at(c + 1, n, r + 1), at(c, n, r + 1)], stickers[i]);
        final top = n - r;
        sticker([
          at(c, top, n),
          at(c + 1, top, n),
          at(c + 1, top - 1, n),
          at(c, top - 1, n),
        ], stickers[face + i]);
        final left = n - c;
        sticker([
          at(n, top, left),
          at(n, top, left - 1),
          at(n, top - 1, left - 1),
          at(n, top - 1, left),
        ], stickers[2 * face + i]);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CubeIsoPainter old) =>
      old.stickers != stickers || !CubeCasePainter._sameColors(old.colors, colors);
}

/// The space between the two faces of [CubeFacesPainter], in stickers.
const _facesGap = 0.7;

/// Width over height of the drawing of [CubeFacesPainter], so a box of that shape has no room left over.
double cubeFacesAspectRatio(String stickers) {
  final n = cubeFaceStickersSize(stickers);
  final face = n + (n - 1) * _gap;
  return face / (2 * face + _facesGap);
}

class CubeFacesPainter extends CustomPainter {
  CubeFacesPainter({required this.stickers, required this.colors}) : n = cubeFaceStickersSize(stickers);

  final String stickers;
  final Map<String, Color> colors;
  final int n;

  @override
  void paint(Canvas canvas, Size size) {
    final face = n + (n - 1) * _gap; // in stickers
    final height = 2 * face + _facesGap;
    final cell = math.min(size.width / face, size.height / height);
    canvas.save();
    canvas.translate((size.width - face * cell) / 2, (size.height - height * cell) / 2);

    final step = cell * (1 + _gap);
    final stroke = cell * 6 / 139;
    for (var f = 0; f < 2; f++) {
      final top = f * (face + _facesGap) * cell;
      for (var i = 0; i < n * n; i++) {
        final rect = Rect.fromLTWH((i % n) * step, top + (i ~/ n) * step, cell, cell);
        _drawSticker(canvas, rect, cell / 4, stroke, colors[stickers[f * n * n + i]] ?? _unknownColor);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CubeFacesPainter old) =>
      old.stickers != stickers || !CubeCasePainter._sameColors(old.colors, colors);
}
