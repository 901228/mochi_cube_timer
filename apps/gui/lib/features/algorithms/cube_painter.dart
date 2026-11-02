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
    final settings = SettingsProvider.of(context);
    return CustomPaint(
      painter: CubeCasePainter(
        stickers: stickers,
        colors: {
          "y": settings.cubeColorD.toColor(),
          "w": settings.cubeColorU.toColor(),
          "g": settings.cubeColorF.toColor(),
          "b": settings.cubeColorB.toColor(),
          "o": settings.cubeColorL.toColor(),
          "r": settings.cubeColorR.toColor(),
        },
      ),
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

    void draw(Rect rect, double radius, Color fill) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)), Paint()..color = fill);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(stroke / 2), Radius.circular(radius - stroke / 2)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = _unknownColor,
      );
    }

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
