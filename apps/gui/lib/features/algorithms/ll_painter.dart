import "dart:math" as math;
import "dart:ui" show ImageFilter;

import "package:flutter/foundation.dart" show listEquals;
import "package:flutter/widgets.dart";

/// One swap arrow on a PLL diagram, between two cells of the 3x3 U face (`0..8` in reading order).
@immutable
class PllArrow {
  const PllArrow(this.from, this.to, {this.bidirectional = false});

  /// Source cell index (`0..8`, row-major from top-left).
  final int from;

  /// Target cell index (`0..8`, row-major from top-left).
  final int to;

  /// Whether to draw arrowheads on both ends (`<->`).
  final bool bidirectional;

  bool get isCorner =>
      (from == 0 || from == 2 || from == 6 || from == 8) && (to == 0 || to == 2 || to == 6 || to == 8);

  @override
  bool operator ==(Object other) =>
      other is PllArrow && other.from == from && other.to == to && other.bidirectional == bidirectional;

  @override
  int get hashCode => Object.hash(from, to, bidirectional);
}

const _gridStarts = [53.0, 215.0, 377.0];
const _cellSize = 139.0;
const _cellRadius = 35.0;
const _cellStroke = 6.0;
const _canvasExtent = 569.0;
const _unorientedColor = Color(0xFF777777);

/// Draws the 21-sticker OLL top-down diagram on the `569 x 569` coordinate grid.
///
/// [mask] is a 21-bit integer:
/// - bits `0..8`: the 3x3 U face in reading order (`row * 3 + col`).
/// - bits `9..11`: top (B) side bars, left to right (`col 0..2`).
/// - bits `12..14`: right (R) side bars, top to bottom (`row 0..2`).
/// - bits `15..17`: bottom (F) side bars, left to right (`col 0..2`).
/// - bits `18..20`: left (L) side bars, top to bottom (`row 0..2`).
class OllCasePainter extends CustomPainter {
  const OllCasePainter({required this.mask, required this.topColor});

  final int mask;
  final Color topColor;

  bool _bit(int index) => (mask & (1 << index)) != 0;

  static void _drawCell(Canvas canvas, Rect rect, Color fill) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(_cellRadius));
    canvas.drawRRect(rrect, Paint()..color = fill);
    // Inner stroke of width 6 (equivalent to SVG stroke-width="6" clipped to the shape's mask).
    final inner = rect.deflate(_cellStroke / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(inner, const Radius.circular(_cellRadius - _cellStroke / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _cellStroke
        ..color = _unorientedColor,
    );
  }

  static void _drawBar(Canvas canvas, Rect rect, Color fill) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(15));
    canvas.drawRRect(rrect, Paint()..color = fill);
    final inner = rect.deflate(_cellStroke / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(inner, const Radius.circular(15 - _cellStroke / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _cellStroke
        ..color = _unorientedColor,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / _canvasExtent;
    final dx = (size.width - _canvasExtent * scale) / 2;
    final dy = (size.height - _canvasExtent * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    // 3x3 U face cells
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        final rect = Rect.fromLTWH(_gridStarts[col], _gridStarts[row], _cellSize, _cellSize);
        _drawCell(canvas, rect, _bit(row * 3 + col) ? topColor : _unorientedColor);
      }
    }

    // Top (B) bars: bits 9..11
    for (var col = 0; col < 3; col++) {
      final rect = Rect.fromLTWH(_gridStarts[col], 0, _cellSize, 30);
      _drawBar(canvas, rect, _bit(9 + col) ? topColor : _unorientedColor);
    }

    // Right (R) bars: bits 12..14
    for (var row = 0; row < 3; row++) {
      final rect = Rect.fromLTWH(539, _gridStarts[row], 30, _cellSize);
      _drawBar(canvas, rect, _bit(12 + row) ? topColor : _unorientedColor);
    }

    // Bottom (F) bars: bits 15..17
    for (var col = 0; col < 3; col++) {
      final rect = Rect.fromLTWH(_gridStarts[col], 539, _cellSize, 30);
      _drawBar(canvas, rect, _bit(15 + col) ? topColor : _unorientedColor);
    }

    // Left (L) bars: bits 18..20
    for (var row = 0; row < 3; row++) {
      final rect = Rect.fromLTWH(0, _gridStarts[row], 30, _cellSize);
      _drawBar(canvas, rect, _bit(18 + row) ? topColor : _unorientedColor);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(OllCasePainter oldDelegate) =>
      oldDelegate.mask != mask || oldDelegate.topColor != topColor;
}

/// Draws the 3x3 U face with permutation arrows for a PLL case on the `463 x 463` coordinate grid.
class PllCasePainter extends CustomPainter {
  const PllCasePainter({
    required this.arrows,
    required this.topColor,
    this.strokeWidth = 7.0,
    this.cornerArrowColor = const Color(0xFF6CBEFA),
    this.edgeArrowColor = const Color(0xFFFA8080),
  });

  final List<PllArrow> arrows;
  final Color topColor;
  final double strokeWidth;
  final Color cornerArrowColor;
  final Color edgeArrowColor;

  static const _pllExtent = 463.0;
  static const _pllStarts = [0.0, 162.0, 324.0];

  static Offset _centerOf(int cell) {
    final row = cell ~/ 3;
    final col = cell % 3;
    return Offset(_pllStarts[col] + _cellSize / 2, _pllStarts[row] + _cellSize / 2);
  }

  /// Whether [cell] lies strictly along the line segment of another arrow (excluding [self]).
  bool _passedThroughByOther(int cell, PllArrow self) {
    final p = _centerOf(cell);
    for (final other in arrows) {
      if (identical(other, self) || other == self) continue;
      if (other.from == cell || other.to == cell) continue;
      final a = _centerOf(other.from);
      final b = _centerOf(other.to);
      final ab = b - a;
      final ap = p - a;
      final cross = (ab.dx * ap.dy - ab.dy * ap.dx).abs();
      final dot = ab.dx * ap.dx + ab.dy * ap.dy;
      if (cross < 1e-3 && dot > 0 && dot < ab.distanceSquared) return true;
    }
    return false;
  }

  Path _arrowPath(PllArrow arrow) {
    final rawStart = _centerOf(arrow.from);
    final rawEnd = _centerOf(arrow.to);
    final delta = rawEnd - rawStart;
    if (delta == Offset.zero) return Path();

    final step = Offset(delta.dx.sign, delta.dy.sign);
    Offset start = rawStart;
    Offset end = rawEnd;

    if (!arrow.bidirectional) {
      // In a 3-cycle, any corner/edge whose adjacent side is not crossed by the long diagonal arrow
      // pulls its endpoint inward by 35 units along each active axis (69 -> 104, 359 <- 394) so the
      // arrow head and tail meet cleanly around the cell without colliding.
      bool trimsAt(int cell) {
        if (!arrow.isCorner) return true;
        final isDiag = (arrow.from % 3 != arrow.to % 3) && (arrow.from ~/ 3 != arrow.to ~/ 3);
        if (isDiag) return true;
        // For the two axis-aligned legs of a corner 3-cycle:
        // - In Aa/Ab, the diagonal runs between 0 and 8, so the two axis legs share corner 2 and
        //   trim there, while anchoring at the diagonal's corners (0 and 8) with 0 offset.
        // - In Ga/Gb/Gc/Gd, the diagonal runs between 2 and 6 (Ga/Gd) or 0 and 8 (Gb/Gc); the two
        //   axis legs trim at their shared corner (0 or 6) and anchor at the other two corners.
        final otherAxisLeg = arrows
            .where(
              (a) => a != arrow && a.isCorner && !((a.from % 3 != a.to % 3) && (a.from ~/ 3 != a.to ~/ 3)),
            )
            .firstOrNull;
        if (otherAxisLeg == null) return true;
        final sharedCorner = (arrow.from == otherAxisLeg.from || arrow.from == otherAxisLeg.to)
            ? arrow.from
            : arrow.to;
        return cell == sharedCorner;
      }

      if (trimsAt(arrow.from)) start += step * 35.0;
      if (trimsAt(arrow.to)) end -= step * 35.0;
    } else {
      // Bidirectional arrows:
      // - T perm's 3<->5 has its right endpoint (cell 5) sitting on the vertical corner swap 8<->2,
      //   so that endpoint retreats by 18 units along the arrow.
      // - Ja (5<->1) and Jb (5<->7) are diagonal edge swaps whose cell 5 sits on the vertical
      //   corner swap 8<->2, so the whole arrow shifts 17 units away from column 2 (leftward) and
      //   17 units along the vertical axis toward cell 5's interior.
      if (_passedThroughByOther(arrow.from, arrow)) {
        final shiftY = (rawEnd.dy - rawStart.dy).sign * 16.5;
        start += Offset(-17, shiftY);
        end += Offset(-17, shiftY);
      } else if (_passedThroughByOther(arrow.to, arrow)) {
        end -= step * 18.0;
      }
    }

    final dir = (end - start) / (end - start).distance;
    const wingProj = 22.2739; // 31.5 * cos(pi / 4)
    final perp = Offset(-dir.dy, dir.dx);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    final w1 = end - dir * wingProj + perp * wingProj;
    final w2 = end - dir * wingProj - perp * wingProj;
    path
      ..moveTo(w1.dx, w1.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(w2.dx, w2.dy);

    if (arrow.bidirectional) {
      final s1 = start + dir * wingProj + perp * wingProj;
      final s2 = start + dir * wingProj - perp * wingProj;
      path
        ..moveTo(s1.dx, s1.dy)
        ..lineTo(start.dx, start.dy)
        ..lineTo(s2.dx, s2.dy);
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / _pllExtent;
    final dx = (size.width - _pllExtent * scale) / 2;
    final dy = (size.height - _pllExtent * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        final rect = Rect.fromLTWH(_pllStarts[col], _pllStarts[row], _cellSize, _cellSize);
        OllCasePainter._drawCell(canvas, rect, topColor);
      }
    }

    // Corner arrows (blue) first, then edge arrows (pink) on top, matching the SVG layer order.
    final ordered = [...arrows.where((a) => a.isCorner), ...arrows.where((a) => !a.isCorner)];

    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0x40000000)
      ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2);

    for (final arrow in ordered) {
      final path = _arrowPath(arrow);
      canvas.save();
      canvas.translate(0, 4);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();

      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = arrow.isCorner ? cornerArrowColor : edgeArrowColor;
      canvas.drawPath(path, strokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(PllCasePainter oldDelegate) =>
      !listEquals(oldDelegate.arrows, arrows) ||
      oldDelegate.topColor != topColor ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.cornerArrowColor != cornerArrowColor ||
      oldDelegate.edgeArrowColor != edgeArrowColor;
}
