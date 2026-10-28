
import "package:flutter/foundation.dart" show listEquals;
import "package:flutter/widgets.dart";

import "../../database/dao_provider.dart";
import "../../shared/utils.dart";

// The last layer seen from above, in the units of the drawing it follows: the hexagon is the six
// triangles round the centre of the layer's face and the corner triangles stand on every other side.
const _o = Offset(380, 285);
const _a = Offset(300, 148);
const _b = Offset(460, 148);
const _c = Offset(540, 285);
const _d = Offset(460, 420);
const _e = Offset(300, 420);
const _f = Offset(220, 285);
const _a2 = Offset(178, 75);
const _b2 = Offset(583, 75);
const _c2 = Offset(660, 210);
const _d2 = Offset(460, 557);
const _e2 = Offset(300, 557);
const _f2 = Offset(100, 210);
const _top = Offset(380, 75);
const _u1 = Offset(200, 180);
const _u2 = Offset(560, 180);
const _u3 = Offset(380, 490);
const _g1 = Offset(203, 388);
const _g2 = Offset(557, 388);

const _width = 560.0;
const _height = 482.0;
const _origin = Offset(100, 75);

typedef _Triangle = (Offset, Offset, Offset);

/// The layer's own triangles, all solved.
const List<_Triangle> _hexagon = [
  (_o, _a, _b),
  (_o, _b, _c),
  (_o, _c, _d),
  (_o, _d, _e),
  (_o, _e, _f),
  (_o, _f, _a),
];

/// The nine stickers a case is made of: the top row left to right, then the left column and the
/// right column from the top down.
const List<_Triangle> _stickers = [
  (_a2, _top, _a),
  (_a, _b, _top),
  (_b, _top, _b2),
  (_f2, _g1, _f),
  (_f, _e, _g1),
  (_g1, _e2, _e),
  (_c2, _g2, _c),
  (_c, _d, _g2),
  (_g2, _d2, _d),
];

/// Everything else the case does not say anything about.
const List<_Triangle> _unknown = [
  (_a, _f, _u1),
  (_b, _c, _u2),
  (_e, _d, _u3),
  (_a2, _u1, _a),
  (_a2, _f2, _u1),
  (_f2, _f, _u1),
  (_b2, _u2, _b),
  (_b2, _c2, _u2),
  (_c2, _c, _u2),
  (_e, _e2, _u3),
  (_d, _d2, _u3),
  (_e2, _d2, _u3),
];

/// Darker than any face's grey, so "no matter" is never taken for a sticker.
const _unknownColor = Color(0xFF444444);

/// An FTO last-layer case: [stickers] says which face each sticker belongs to, the nine of
/// [_stickers] first and then those of [_unknown] if the case has any to say, with `y` for the
/// layer's own face, `o` BL, `g` F, `l` BR, `r` R, `b` B and `p` L. Any other letter, or none, is a
/// sticker that does not matter.
class FtoCaseDiagram extends StatelessWidget {
  const FtoCaseDiagram({super.key, required this.stickers});

  final String stickers;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    return CustomPaint(
      painter: FtoCasePainter(
        stickers: stickers,
        layerColor: settings.ftoColorD.toColor(),
        colors: {
          "y": settings.ftoColorD.toColor(),
          "o": settings.ftoColorBL.toColor(),
          "g": settings.ftoColorF.toColor(),
          "l": settings.ftoColorBR.toColor(),
          "r": settings.ftoColorR.toColor(),
          "b": settings.ftoColorB.toColor(),
          "p": settings.ftoColorL.toColor(),
        },
      ),
    );
  }
}

class FtoCasePainter extends CustomPainter {
  const FtoCasePainter({required this.stickers, required this.layerColor, required this.colors});

  final String stickers;
  final Color layerColor;

  /// By the letters of [stickers].
  final Map<String, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / _width).clamp(0.0, size.height / _height);
    final shift = Offset(
      (size.width - _width * scale) / 2,
      (size.height - _height * scale) / 2,
    );

    Offset at(Offset p) => (p - _origin) * scale + shift;

    final fill = Paint();
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * scale
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF111111);

    void draw(_Triangle t, Color color) {
      final path = Path()
        ..moveTo(at(t.$1).dx, at(t.$1).dy)
        ..lineTo(at(t.$2).dx, at(t.$2).dy)
        ..lineTo(at(t.$3).dx, at(t.$3).dy)
        ..close();
      canvas.drawPath(path, fill..color = color);
      canvas.drawPath(path, line);
    }

    Color colorOf(int i) => i < stickers.length ? colors[stickers[i]] ?? _unknownColor : _unknownColor;

    for (var i = 0; i < _unknown.length; i++) {
      draw(_unknown[i], colorOf(_stickers.length + i));
    }
    for (final t in _hexagon) {
      draw(t, layerColor);
    }
    for (var i = 0; i < _stickers.length; i++) {
      draw(_stickers[i], colorOf(i));
    }
  }

  @override
  bool shouldRepaint(FtoCasePainter old) =>
      old.stickers != stickers || old.layerColor != layerColor || !_sameColors(old.colors, colors);

  static bool _sameColors(Map<String, Color> a, Map<String, Color> b) =>
      listEquals(a.values.toList(), b.values.toList());
}
