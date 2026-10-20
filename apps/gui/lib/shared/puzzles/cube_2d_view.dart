import "dart:math" show cos, max, min, pi, sin, sqrt;

import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart" show listEquals, mapEquals;
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../utils.dart";
import "square1_painter.dart";

class Cube2DView extends StatelessWidget {
  static const Curve heroFlightCurve = Curves.fastOutSlowIn;

  const Cube2DView({
    super.key,
    required this.puzzle,
    required this.state,
    this.settings,
    this.compact = false,
  });

  final Puzzle puzzle;

  /// One number per piece of the puzzle's layout — a [Scramble.state], or the
  /// state part way through a scramble.
  final List<int> state;

  final SettingsEntry? settings;

  /// A small picture for the timer page rather than the enlarged one; only the Square-1 differs,
  /// laying its layers side by side.
  final bool compact;

  List<Color> _colorsFor(Puzzle puzzle, SettingsEntry settings) {
    return switch (puzzle) {
      .cube2 || .cube3 || .cube4 || .cube5 || .cube6 || .cube7 || .skewb => [
        settings.cubeColorU.toColor(),
        settings.cubeColorR.toColor(),
        settings.cubeColorF.toColor(),
        settings.cubeColorD.toColor(),
        settings.cubeColorL.toColor(),
        settings.cubeColorB.toColor(),
      ],
      // The Square-1 is scrambled with U up and R in front, so what the layout calls the right, front,
      // left and back are the cube's B, R, F and L: the cube's colours turned a quarter.
      .sq1 => [
        settings.cubeColorU.toColor(),
        settings.cubeColorB.toColor(),
        settings.cubeColorR.toColor(),
        settings.cubeColorD.toColor(),
        settings.cubeColorF.toColor(),
        settings.cubeColorL.toColor(),
      ],
      // A face is named for the vertex it lacks, and the vertices are numbered as the moves are: U, L, R, B.
      .pyraminx => [
        settings.pyraminxColorU.toColor(),
        settings.pyraminxColorL.toColor(),
        settings.pyraminxColorR.toColor(),
        settings.pyraminxColorB.toColor(),
      ],
      // The layout's faces in order: U and the five round it, then D and the five round it.
      // csTimer's FTO colours, in the layout's face order: U, R, F, L, B, BL, D, BR. Fixed rather
      // than a setting, as with the Megaminx; a setting can follow once the colours are settled.
      .fto => const [
        Color(0xFFFFFFFF), // U
        Color(0xFFFF0000), // R
        Color(0xFF00DD00), // F
        Color(0xFF880088), // L
        Color(0xFF0000FF), // B
        Color(0xFFFFAA00), // BL
        Color(0xFFFFFF00), // D
        Color(0xFFBBBBBB), // BR
      ],
      .megaminx => [
        settings.megaminxColorU.toColor(),
        settings.megaminxColorBL.toColor(),
        settings.megaminxColorBR.toColor(),
        settings.megaminxColorR.toColor(),
        settings.megaminxColorF.toColor(),
        settings.megaminxColorL.toColor(),
        settings.megaminxColorD.toColor(),
        settings.megaminxColorDR.toColor(),
        settings.megaminxColorDBR.toColor(),
        settings.megaminxColorB.toColor(),
        settings.megaminxColorDBL.toColor(),
        settings.megaminxColorDL.toColor(),
      ],
      .clock => throw StateError("Clock colors should not call `_colorsFor()`"),
    };
  }

  Widget _cube(SettingsEntry settings) {
    final layout = puzzle.scrambler.layout;
    final square1 = layout is Square1Layout
        ? Square1Painter(
            layout: layout,
            state: state,
            colors: _colorsFor(puzzle, settings),
            horizontal: compact,
          )
        : null;

    return Hero(
      tag: "cube_2d_view-$puzzle",
      curve: heroFlightCurve,
      child: AspectRatio(
        aspectRatio: square1?.aspectRatio ?? layout.width / layout.height,
        child: CustomPaint(
          isComplex: true,
          painter:
              square1 ??
              switch (layout) {
                final PuzzleLayout puzzleLayout => PuzzlePainter(
                  layout: puzzleLayout,
                  state: state,
                  colors: _colorsFor(puzzle, settings),
                  faces: switch (puzzle) {
                    .pyraminx => 4,
                    .megaminx => 12,
                    .fto => 8,
                    _ => 6,
                  },
                  inset: 0.06,
                  // The Megaminx has no colour scheme to read its orientation from, as the cubes do.
                  labels: puzzle == .megaminx ? const {0: "U", 4: "F"} : const {},
                ),
                final ClockLayout clockLayout => ClockPainter(
                  layout: clockLayout,
                  state: state,
                  color: ClockPainterColor(
                    lightFace: settings.clockColorFront.toColor(),
                    darkFace: settings.clockColorBack.toColor(),
                  ),
                ),
                Square1Layout() => throw StateError("The Square-1 is drawn by its own painter"),
              },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return settings != null
        ? _cube(settings!)
        : StreamBuilder(
            stream: context.read<AppDatabase>().settingsDao.watch(),
            builder: (context, snapshot) {
              final w = streamHandler(
                context,
                snapshot,
                description: "watching the settings for the cube view",
              );
              if (w != null) return w;

              return _cube(snapshot.data!);
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
    this.faces = 1,
    this.inset = 0,
    this.labels = const {},
  });

  final PuzzleLayout layout;
  final List<int> state; // scramble.state
  final List<Color> colors; // 用 state 的值當索引
  final Color stroke;

  /// How many faces the stickers make, each an equal run of them in order.
  final int faces;

  /// How far each face shrinks toward its middle, so a gap appears between faces; 0 is none.
  final double inset;

  /// Letters to write on the middle of some faces, by face number.
  final Map<int, String> labels;

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
      final path = _pathOf(i, scale, dx, dy);
      fill.color = colors[state[i]];
      canvas.drawPath(path, fill);
      canvas.drawPath(path, line);
    }

    // Too small to read, and only a smudge on the stickers.
    if (scale * 0.75 < 8) return;
    for (final MapEntry(key: face, value: text) in labels.entries) {
      // The letter goes in the face's middle sticker, as big as fits there: it is about as wide and
      // tall as a circle of its own size. When the sticker is too small for a readable one, the
      // letter overlaps the lines round it.
      final middle = layout[(face + 1) * (layout.length ~/ faces) - 1];
      final cx = middle.fold(0.0, (sum, p) => sum + p.$1) / middle.length;
      final cy = middle.fold(0.0, (sum, p) => sum + p.$2) / middle.length;
      final fontSize = max(_inradius(middle) * (1 - inset) * scale * 1.7, 9.0);
      // Outlined in white so it reads on any sticker, as csTimer's does, without the weight that
      // would run a small letter together.
      for (final stroked in [true, false]) {
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1,
              foreground: Paint()
                ..style = stroked ? PaintingStyle.stroke : PaintingStyle.fill
                ..strokeWidth = fontSize * 0.14
                ..strokeJoin = StrokeJoin.round
                ..color = stroked ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        // A capital sits on the baseline and stands about 0.7 of the size above it, so it is centred
        // from there: the line's own middle is lower than the letter's.
        final baseline = painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
        painter.paint(
          canvas,
          Offset(dx + cx * scale - painter.width / 2, dy + cy * scale + fontSize * 0.35 - baseline),
        );
      }
    }
  }

  /// How far the nearest side of a convex [polygon] is from the mean of its corners.
  static double _inradius(List<Point> polygon) {
    final cx = polygon.fold(0.0, (sum, p) => sum + p.$1) / polygon.length;
    final cy = polygon.fold(0.0, (sum, p) => sum + p.$2) / polygon.length;
    var nearest = double.infinity;
    for (var i = 0; i < polygon.length; i++) {
      final (x1, y1) = polygon[i];
      final (x2, y2) = polygon[(i + 1) % polygon.length];
      final length = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
      nearest = min(nearest, ((x2 - x1) * (cy - y1) - (y2 - y1) * (cx - x1)).abs() / length);
    }
    return nearest;
  }

  /// The middle of each face, as the mean of its stickers' corners.
  late final List<Point> _faceCentres = () {
    final perFace = layout.length ~/ faces;
    return [
      for (var face = 0; face < faces; face++)
        () {
          var (cx, cy, n) = (0.0, 0.0, 0);
          for (final polygon in layout.stickers.skip(face * perFace).take(perFace)) {
            for (final (x, y) in polygon) {
              cx += x;
              cy += y;
              n++;
            }
          }
          return (cx / n, cy / n);
        }(),
    ];
  }();

  /// Shrink each sticker toward the middle of its face, so the faces stand apart
  /// while the stickers of one face still touch.
  Path _pathOf(int sticker, double scale, double dx, double dy) {
    final polygon = layout[sticker];
    final (cx, cy) = _faceCentres[sticker ~/ (layout.length ~/ faces)];

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
      old.faces != faces ||
      old.inset != inset ||
      !mapEquals(old.labels, labels) ||
      !listEquals(old.state, state) ||
      !listEquals(old.colors, colors);

  @override
  bool? hitTest(Offset position) {
    final (:scale, :dx, :dy) = layout.fitInto(_lastSize.width, _lastSize.height);
    for (var i = 0; i < layout.length; i++) {
      if (_pathOf(i, scale, dx, dy).contains(position)) return true;
    }
    return false;
  }
}

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

    // Dials 0-8 are the front, 9-17 the back, and the layout puts the back on
    // the left. The left side is the darker one, so the front takes the light
    // faces even though it comes first.
    for (var side = 0; side < 2; side++) {
      final front = side == 0;
      final body = front ? darkFill : lightFill;
      final dial = front ? lightFill : darkFill;
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
    // Pins 0-3 belong to the front and 4-7 to the back, in the same order the
    // dials are, so they take the same sides as the bodies they sit on.
    for (var i = 0; i < 4; i++) {
      final centre = at(layout.pins[i]);
      canvas.drawCircle(centre, pinRadius, darkPin);
      canvas.drawCircle(centre, pinRadius, stroke);
    }
    for (var i = 4; i < 8; i++) {
      final centre = at(layout.pins[i]);
      canvas.drawCircle(centre, pinRadius, lightPin);
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
