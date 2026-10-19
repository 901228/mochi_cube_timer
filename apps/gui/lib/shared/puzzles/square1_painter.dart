import "dart:math" show max, min, sqrt2;

import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart" show listEquals, visibleForTesting;
import "package:flutter/widgets.dart";

/// Draws a Square-1 with the layers one above the other, as the layout has them, or side by side
/// as csTimer does:
///
/// ```
/// [top]    [middle]
/// [middle] [bottom]
/// ```
///
/// Side by side makes a picture about twice as wide as it is tall, which is what the small one under
/// the timer wants; the enlarged one has the height for the layers stacked.
class Square1Painter extends CustomPainter {
  Square1Painter({
    required this.layout,
    required this.state,
    required this.colors,
    this.horizontal = false,
    this.stroke = const Color(0xFF000000),
  });

  final Square1Layout layout;
  final List<int> state;

  /// The colour of each face, in the order the layout numbers them: U, R, F, D, L, B.
  final List<Color> colors;

  final bool horizontal;
  final Color stroke;

  /// The least space between two things that do not touch: a bar and a layer's flat side, or the two
  /// layers' corners where both point at the bar.
  static const double _spacing = 0.11;

  /// A layer's box is as wide as the layout is, and a corner's tip reaches half of that from the middle.
  double get _layer => layout.width;
  double get _tip => _layer / 2;

  /// How far a square layer's flat side is from its middle: half its corner to corner width over √2.
  double get _side => _layer / 2 / sqrt2;

  /// The middle bar's top edge and height in the layout.
  double get _barTop => layout.middle.first.map((p) => p.$2).reduce(min);
  double get _bar => layout.height - 2 * _barTop;

  /// The distance between the two layers' middles. Wide enough for two corners pointing at the bar to
  /// keep [_spacing] apart, and for two flat sides with the bar between them.
  double get _middles => max(2 * _tip + _spacing, 2 * _side + 2 * _spacing + _bar);

  /// The gap between the bar and a flat side. It is the same as [_spacing] when the middles are
  /// the flat ones, and wider when corners need the room; either way it is fixed, so the bar never
  /// moves as the layers turn.
  double get _gap => (_middles - _bar) / 2 - _side;

  /// The layers' middles in the layout.
  double get _topMiddle => _layer / 2;
  double get _bottomMiddle => layout.height - _layer / 2;

  /// Where the bar under the top layer starts.
  double get _barUnderTop => _topMiddle + _side + _gap;

  /// Where the bottom layer's middle goes.
  double get _bottom => horizontal ? pictureHeight - _layer / 2 : _topMiddle + _middles;

  double get pictureWidth => horizontal ? 2 * _layer + _spacing : _layer;
  double get pictureHeight => horizontal ? max(_layer, _barUnderTop + _bar) : _layer + _middles;

  /// The picture's shape, for the box it is drawn in.
  double get aspectRatio => pictureWidth / pictureHeight;

  /// Every polygon to draw with the face it shows, moved from the layout's places to these. Side by
  /// side, the bottom layer moves up next to the top and the middle bar, which is the same either
  /// way, is drawn again above it.
  @visibleForTesting
  List<(List<Point>, int)> get polygonsForTest => _polygons;

  List<(List<Point>, int)> get _polygons {
    final column = _layer + _spacing;
    // The bar goes first so the layers' faces are drawn over it.
    final bars = <(List<Point>, int)>[];
    final layers = <(List<Point>, int)>[];
    for (final (polygon, face) in layout.stickers(state)) {
      final y = polygon.map((p) => p.$2).reduce((a, b) => a + b) / polygon.length;
      if (y < _layer) {
        layers.add((polygon, face));
      } else if (y > layout.height - _layer) {
        layers.add((_moved(polygon, horizontal ? column : 0, _bottom - _bottomMiddle), face));
      } else {
        bars.add((_moved(polygon, 0, _barUnderTop - _barTop), face));
        if (horizontal) {
          bars.add((_moved(polygon, column, _bottom - _side - _gap - _bar - _barTop), face));
        }
      }
    }
    return [...bars, ...layers];
  }

  static List<Point> _moved(List<Point> polygon, double dx, double dy) => [
    for (final (x, y) in polygon) (x + dx, y + dy),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / pictureWidth < size.height / pictureHeight
        ? size.width / pictureWidth
        : size.height / pictureHeight;
    final dx = (size.width - pictureWidth * scale) / 2;
    final dy = (size.height - pictureHeight * scale) / 2;

    final fill = Paint()..style = PaintingStyle.fill;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..color = stroke
      ..strokeWidth = scale * 0.025
      ..strokeJoin = StrokeJoin.round;

    for (final (polygon, face) in _polygons) {
      final path = Path();
      for (var i = 0; i < polygon.length; i++) {
        final (x, y) = polygon[i];
        i == 0 ? path.moveTo(dx + x * scale, dy + y * scale) : path.lineTo(dx + x * scale, dy + y * scale);
      }
      path.close();
      fill.color = colors[face];
      canvas.drawPath(path, fill);
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(Square1Painter old) =>
      !identical(old.layout, layout) ||
      old.horizontal != horizontal ||
      old.stroke != stroke ||
      !listEquals(old.state, state) ||
      !listEquals(old.colors, colors);
}
