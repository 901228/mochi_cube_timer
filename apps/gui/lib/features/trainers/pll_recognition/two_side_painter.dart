import "dart:math";

import "package:flutter/foundation.dart" show listEquals, setEquals;
import "package:mochi_ui/mochi_ui.dart";

import "package:cube_timer/cube_timer.dart" show SettingsEntry;

import "../../../database/dao_provider.dart";
import "../../../shared/utils.dart";

/// The top layer of a cube held by its front-right corner: the top face, and the top row of the front
/// side and of the right side, which is all that a two-sided PLL recognition goes by.
///
/// [stickers] are the faces the six stickers belong to, the front's from left to right and then the
/// right's from front to back, as `pllTwoSide` gives them. A negative one is a sticker that does not
/// matter, which is drawn grey.
///
/// Given [shown] and [framed], as a recognition rule's are: only the stickers (by position) in [shown]
/// are in colour, the rest being grey, and those in [framed] have a heavy black frame, the others a thin
/// grey one.
class TwoSideDiagram extends StatelessWidget {
  const TwoSideDiagram({super.key, required this.stickers, this.shown, this.framed});

  final List<int> stickers;
  final Set<int>? shown;
  final Set<int>? framed;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    return CustomPaint(
      painter: TwoSidePainter(
        stickers: stickers,
        shown: shown,
        framed: framed,
        // U R F D L B, the order of the face indices. The last layer is on the colour of the bottom, as
        // in the rest of the algorithms, so the cube is held upside down about its front: left and right
        // change places with it, which keeps it a cube that can be made.
        faceColors: cubeFaceColors(settings),
        outline: context.colors.foreground,
        unknown: context.colors.mutedForeground.withValues(alpha: 0.4),
      ),
    );
  }
}

/// The colours of the faces, by index of the faces as [pllTwoSide] gives them (U R F D L B). The last
/// layer is on the colour of the bottom, as in the rest of the algorithms, so the cube is held upside
/// down about its front: left and right change places with it, which keeps it a cube that can be made.
List<Color> cubeFaceColors(SettingsEntry settings) => [
  for (final c in [
    settings.cubeColorD,
    settings.cubeColorL,
    settings.cubeColorF,
    settings.cubeColorU,
    settings.cubeColorR,
    settings.cubeColorB,
  ])
    c.toColor(),
];

/// How wide and tall [TwoSidePainter] draws, in the length of a sticker's side.
const twoSideAspectRatio = 6 * _cos30 / 4;

const _cos30 = 0.8660254037844386;

// The same in either theme: a frame that is black, and a line that is grey.
const _black = Color(0xFF000000);
const _grey = Color(0xFF9E9E9E);

class TwoSidePainter extends CustomPainter {
  const TwoSidePainter({
    required this.stickers,
    this.shown,
    this.framed,
    required this.faceColors,
    required this.outline,
    required this.unknown,
  });

  final List<int> stickers;
  final Set<int>? shown;
  final Set<int>? framed;
  final List<Color> faceColors;
  final Color outline;
  final Color unknown;

  @override
  void paint(Canvas canvas, Size size) {
    // The cube is drawn in units of a sticker's side, with its front-right corner at the origin: the
    // top face's edges run along `toFront` and `toBack`, and the sides hang down by `down`.
    const toFront = Offset(_cos30, 0.5);
    const toBack = Offset(_cos30, -0.5);
    const down = Offset(0, 1);
    final frontLeft = toFront * -3;

    // 6 * _cos30 wide, from the front-left corner to the back-right, and 4 tall: three units of the top
    // face and one of the sides below it.
    final scale = min(size.width / (6 * _cos30), size.height / 4);
    final origin = Offset(size.width / 2, size.height / 2 + 1 * scale);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.07
      ..strokeJoin = StrokeJoin.round
      ..color = framed == null ? outline : _grey;

    Path quad(Offset a, Offset u, Offset v, Color color) {
      final path = Path()
        ..moveTo(origin.dx + a.dx * scale, origin.dy + a.dy * scale)
        ..lineTo(origin.dx + (a + u).dx * scale, origin.dy + (a + u).dy * scale)
        ..lineTo(origin.dx + (a + u + v).dx * scale, origin.dy + (a + u + v).dy * scale)
        ..lineTo(origin.dx + (a + v).dx * scale, origin.dy + (a + v).dy * scale)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(path, line);
      return path;
    }

    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        quad(frontLeft + toFront * i.toDouble() + toBack * j.toDouble(), toFront, toBack, faceColors[0]);
      }
    }
    Color colorOf(int i) =>
        stickers[i] < 0 || !(shown?.contains(i) ?? true) ? unknown : faceColors[stickers[i]];
    final marked = <Path>[];
    for (var i = 0; i < 3; i++) {
      final front = quad(frontLeft + toFront * i.toDouble(), toFront, down, colorOf(i));
      final right = quad(toBack * i.toDouble(), toBack, down, colorOf(3 + i));
      if (framed?.contains(i) ?? false) marked.add(front);
      if (framed?.contains(3 + i) ?? false) marked.add(right);
    }
    // After all of them, so a neighbour's edge does not cover a frame.
    final frame = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.17
      ..strokeJoin = StrokeJoin.round
      ..color = _black;
    for (final path in marked) {
      canvas.drawPath(path, frame);
    }
  }

  @override
  bool shouldRepaint(TwoSidePainter old) =>
      old.outline != outline ||
      !listEquals(old.stickers, stickers) ||
      !setEquals(old.shown, shown) ||
      !setEquals(old.framed, framed) ||
      !listEquals(old.faceColors, faceColors);
}
