import "dart:math" show cos, sin, pi;
import "dart:ui";

import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter/foundation.dart" show listEquals;
import "package:forui/forui.dart";

class Cube2DView extends StatelessWidget {
  final ScrambleHistory history;
  const Cube2DView({super.key, required this.history});

  Widget _buildCube(Scramble scramble) {
    final layout = history.puzzle.scrambler.layout;

    return Hero(
      tag: "cube_2d_view-${history.puzzle}",
      child: AspectRatio(
        aspectRatio: layout.width / layout.height,
        child: CustomPaint(
          isComplex: true,
          painter: switch (layout) {
            final PuzzleLayout puzzleLayout => PuzzlePainter(
              layout: puzzleLayout,
              state: scramble.state,
              // colors: colorsFor(scrambler.id),
              colors: [
                Color(0xFFFFFFFF), // U
                Color(0xFFB71C1C), // R
                Color(0xFF2E7D32), // F
                Color(0xFFFDD835), // D
                Color(0xFFEF6C00), // L
                Color(0xFF1565C0), // B
              ],
            ),
            final ClockLayout clockLayout => ClockPainter(layout: clockLayout, state: scramble.state),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: history.current,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("打亂失敗：${snapshot.error}");
        }

        final scramble = snapshot.data;
        if (scramble == null) {
          return const FCircularProgress();
        }

        return FTappable(
          onPress: () {
            final routeStyle = context.theme.dialogRouteStyle;
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                transitionDuration: routeStyle.motion.entranceDuration,
                pageBuilder: (context, animation, _) => Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        behavior: HitTestBehavior.opaque,
                        child: FadeTransition(
                          opacity: animation,
                          child: BackdropFilter(
                            filter:
                                routeStyle.barrierFilter?.call(context, animation.value) ??
                                ImageFilter.blur(),
                            child: const ColoredBox(color: Color(0x00FFFFFF)),
                          ),
                        ),
                      ),
                    ),
                    Center(child: _buildCube(scramble)),
                  ],
                ),
              ),
            );
          },
          child: _buildCube(scramble),
        );
      },
    );
  }
}

class PuzzlePainter extends CustomPainter {
  PuzzlePainter({
    required this.layout,
    required this.state,
    required this.colors,
    this.stroke = const Color(0xFF000000),
    this.inset = 0.1,
  });

  final PuzzleLayout layout;
  final List<int> state; // scramble.state
  final List<Color> colors; // 用 state 的值當索引
  final Color stroke;
  final double inset; // 貼紙縮多少，0 就沒有縫

  Size _lastSize = Size.zero;

  @override
  void paint(Canvas canvas, Size size) {
    _lastSize = size;

    final (:scale, :dx, :dy) = layout.fitInto(size.width, size.height);
    final fill = Paint()..style = PaintingStyle.fill;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..color = stroke
      ..strokeWidth = scale * 0.025
      ..strokeJoin = StrokeJoin.round;

    for (var i = 0; i < layout.length; i++) {
      final path = _pathOf(layout[i], scale, dx, dy);
      fill.color = colors[state[i]];
      canvas.drawPath(path, fill);
      canvas.drawPath(path, line);
    }
  }

  /// Shrink each sticker toward its own middle, so a gap appears between
  /// neighbours without the layout having to carry one.
  Path _pathOf(List<Point> polygon, double scale, double dx, double dy) {
    var cx = 0.0;
    var cy = 0.0;
    for (final (x, y) in polygon) {
      cx += x;
      cy += y;
    }
    cx /= polygon.length;
    cy /= polygon.length;

    final path = Path();
    for (var i = 0; i < polygon.length; i++) {
      final (x, y) = polygon[i];
      final px = dx + (cx + (x - cx) * (1 - inset)) * scale;
      final py = dy + (cy + (y - cy) * (1 - inset)) * scale;
      i == 0 ? path.moveTo(px, py) : path.lineTo(px, py);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(PuzzlePainter old) =>
      !identical(old.layout, layout) ||
      old.stroke != stroke ||
      old.inset != inset ||
      !listEquals(old.state, state) ||
      !listEquals(old.colors, colors);

  @override
  bool? hitTest(Offset position) {
    final (:scale, :dx, :dy) = layout.fitInto(_lastSize.width, _lastSize.height);
    for (var i = 0; i < layout.length; i++) {
      if (_pathOf(layout[i], scale, dx, dy).contains(position)) return true;
    }
    return false;
  }
}

// // 3x3 / 2x2：U R F D L B，WCA 標準配色
// const List<Color> cubeColors = [
//   Colors.white,   // U
//   Color(0xFFB71C1C), // R
//   Color(0xFF2E7D32), // F
//   Color(0xFFFDD835), // D
//   Color(0xFFEF6C00), // L
//   Color(0xFF1565C0), // B
// ];

// // Pyraminx 只有四個面
// const List<Color> pyraminxColors = [
//   Color(0xFF2E7D32),
//   Color(0xFFB71C1C),
//   Color(0xFF1565C0),
//   Colors.yellow,
// ];

// const List<Color> clockColors = [
//   Color(0xFF3F82FF),
//   Color(0xFFD3F5FF),
// ];

class ClockPainterColor {
  const ClockPainterColor({
    this.lightFace = const Color(0xFFD3F5FF),
    this.darkFace = const Color(0xFF3F82FF),
    this.stroke = const Color(0xFF000000),
    this.hand = const Color(0xFFFFC400),
    this.handStroke = const Color(0xFFE53935),
    this.lightPin = const Color(0xFFFFD600),
    this.darkPin = const Color(0xFF7A3E00),
  });

  final Color lightFace, darkFace;
  final Color stroke;
  final Color hand, handStroke;
  final Color lightPin, darkPin;

  @override
  int get hashCode => Object.hash(lightFace, darkFace, stroke, hand, handStroke, lightPin, darkPin);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClockPainterColor &&
          runtimeType == other.runtimeType &&
          lightFace == other.lightFace &&
          darkFace == other.darkFace &&
          stroke == other.stroke &&
          hand == other.hand &&
          handStroke == other.handStroke &&
          lightPin == other.lightPin &&
          darkPin == other.darkPin;
}

class ClockPainter extends CustomPainter {
  ClockPainter({required this.layout, required this.state, this.color = const ClockPainterColor()});

  final ClockLayout layout;
  final List<int> state; // 18 hours, 0..11
  final ClockPainterColor color;

  Size _lastSize = Size.zero;

  (double, Offset Function(Point p)) _fitSize() {
    // determine overall size
    final fit = layout.fitInto(_lastSize.width, _lastSize.height);
    final scale = fit.scale * 0.9;

    // position the dials
    final dx = fit.dx + (fit.scale - scale) * layout.width / 2;
    final dy = fit.dy + (fit.scale - scale) * layout.height / 2;
    Offset at(Point p) => Offset(dx + p.$1 * scale, dy + p.$2 * scale);

    return (scale, at);
  }

  Path _handPath(Offset centre, double angle, double base, double length) {
    final tip = centre + Offset(cos(angle), sin(angle)) * length;
    return Path()
      ..addArc(Rect.fromCircle(center: centre, radius: base), angle + pi / 2, pi)
      ..lineTo(tip.dx, tip.dy)
      ..close();
  }

  /// The nine dial centres of one side, in canvas coordinates.
  List<Offset> _centres(int side, Offset Function(Point p) at) => [
    for (var i = side * 9; i < side * 9 + 9; i++) at(layout.dials[i]),
  ];

  Path _bodyPath(List<Offset> centres, double dialRadius) {
    var left = centres.first.dx, right = centres.first.dx;
    var top = centres.first.dy, bottom = centres.first.dy;
    for (final c in centres) {
      if (c.dx < left) left = c.dx;
      if (c.dx > right) right = c.dx;
      if (c.dy < top) top = c.dy;
      if (c.dy > bottom) bottom = c.dy;
    }

    final pad = dialRadius * 1.5;
    var path = Path()..addOval(Rect.fromLTRB(left - pad, top - pad, right + pad, bottom + pad));

    for (final centre in centres) {
      path = Path.combine(
        PathOperation.union,
        path,
        Path()..addOval(Rect.fromCircle(center: centre, radius: dialRadius * 1.1)),
      );
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _lastSize = size;
    final (scale, at) = _fitSize();

    final bodyRadius = layout.dialRadius * scale;
    final dialRadius = bodyRadius * 0.75;

    // colors
    final lightFill = Paint()..color = color.lightFace;
    final darkFill = Paint()..color = color.darkFace;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = color.stroke
      ..strokeWidth = scale * 0.035
      ..strokeJoin = StrokeJoin.round;

    // calculate the mark offsets
    final markRadius = bodyRadius * 0.07;
    final markOffsets = [
      for (var hour = 0; hour < 12; hour++)
        Offset(cos(hour * pi / 6 - pi / 2), sin(hour * pi / 6 - pi / 2)) * bodyRadius / 1.1,
    ];

    for (var side = 0; side < 2; side++) {
      final front = side == 0;
      final body = front ? lightFill : darkFill;
      final dial = front ? darkFill : lightFill;
      final centres = _centres(side, at);

      // draw body
      final outline = _bodyPath(centres, bodyRadius);
      canvas.drawPath(outline, body);
      canvas.drawPath(outline, stroke);

      // draw marks
      for (final centre in centres) {
        for (final offset in markOffsets) {
          canvas.drawCircle(centre + offset, markRadius, dial);
        }
      }

      // draw dials
      for (final centre in centres) {
        canvas.drawCircle(centre, dialRadius, dial);
        canvas.drawCircle(centre, dialRadius, stroke);
      }
    }

    // draw pins
    final lightPin = Paint()..color = color.lightPin;
    final darkPin = Paint()..color = color.darkPin;
    final pinRadius = layout.pinRadius * scale * 0.65;
    for (var i = 0; i < 4; i++) {
      final centre = at(layout.pins[i]);
      canvas.drawCircle(centre, pinRadius, lightPin);
      canvas.drawCircle(centre, pinRadius, stroke);
    }
    for (var i = 4; i < 8; i++) {
      final centre = at(layout.pins[i]);
      canvas.drawCircle(centre, pinRadius, darkPin);
      canvas.drawCircle(centre, pinRadius, stroke);
    }

    // draw hands
    final handFill = Paint()..color = color.hand;
    final handEdge = Paint()
      ..style = PaintingStyle.stroke
      ..color = color.handStroke
      ..strokeWidth = scale * 0.03
      ..strokeJoin = StrokeJoin.round;
    for (var i = 0; i < layout.dials.length; i++) {
      final angle = state[i] * pi / 6 - pi / 2;
      final path = _handPath(at(layout.dials[i]), angle, dialRadius * 0.15, dialRadius * 0.75);
      canvas.drawPath(path, handFill);
      canvas.drawPath(path, handEdge);
    }
  }

  @override
  bool shouldRepaint(ClockPainter old) =>
      !identical(old.layout, layout) || old.color != color || !listEquals(old.state, state);

  @override
  bool? hitTest(Offset position) {
    if (_lastSize.isEmpty) return false;

    final (scale, at) = _fitSize();
    final bodyRadius = layout.dialRadius * scale;

    // The two bodies are the whole visible shape, so testing them covers the
    // dials, the marks and the pins at once. Reusing _bodyPath rather than
    // approximating it with circles keeps the tappable area from drifting out
    // of step with paint() whenever the outline is tuned.
    for (var side = 0; side < 2; side++) {
      if (_bodyPath(_centres(side, at), bodyRadius).contains(position)) return true;
    }
    return false;
  }
}
