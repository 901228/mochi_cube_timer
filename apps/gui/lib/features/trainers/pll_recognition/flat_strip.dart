import "dart:math";

import "package:flutter/foundation.dart" show listEquals, setEquals;
import "package:mochi_ui/mochi_ui.dart";

import "../../../database/dao_provider.dart";
import "two_side_painter.dart";

/// The width of a gap between the sides of a strip of six, in the width of a sticker.
const _gap = 0.08;

/// How wide a strip of [count] stickers is, for its height.
double flatStripAspectRatio(int count) => count + (count == 6 ? _gap : 0);

/// A row of stickers, flat, as the guide draws them: the three of the front and the three of the right
/// with a gap between, or any other number in a row.
///
/// A negative sticker, and one not in [shown] if that is given, is grey. A sticker in [framed] has a
/// heavy black frame, and the others a thin grey one.
class FlatStrip extends StatelessWidget {
  const FlatStrip({super.key, required this.stickers, this.shown, this.framed});

  final List<int> stickers;
  final Set<int>? shown;
  final Set<int>? framed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: flatStripAspectRatio(stickers.length),
      child: CustomPaint(
        painter: _FlatStripPainter(
          stickers: stickers,
          shown: shown,
          framed: framed,
          faceColors: cubeFaceColors(SettingsProvider.of(context)),
          unknown: context.colors.mutedForeground.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _FlatStripPainter extends CustomPainter {
  const _FlatStripPainter({
    required this.stickers,
    required this.shown,
    required this.framed,
    required this.faceColors,
    required this.unknown,
  });

  final List<int> stickers;
  final Set<int>? shown;
  final Set<int>? framed;
  final List<Color> faceColors;
  final Color unknown;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = min(size.height, size.width / flatStripAspectRatio(stickers.length));
    final thin = scale * 0.05;
    final heavy = scale * 0.13;

    Rect rect(int i) {
      final x = (i + (stickers.length == 6 && i >= 3 ? _gap : 0)) * scale;
      return Rect.fromLTWH(x, 0, scale, scale);
    }

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thin
      ..color = const Color(0xFF9E9E9E);
    final frame = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = heavy
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF000000);

    for (var i = 0; i < stickers.length; i++) {
      final r = rect(i);
      final colored = stickers[i] >= 0 && (shown?.contains(i) ?? true);
      canvas.drawRect(r, Paint()..color = colored ? faceColors[stickers[i]] : unknown);
      canvas.drawRect(r.deflate(thin / 2), line);
    }
    // After all of them, so a neighbour's edge does not cover a frame.
    for (final i in framed ?? const <int>{}) {
      canvas.drawRect(rect(i).deflate(heavy / 2), frame);
    }
  }

  @override
  bool shouldRepaint(_FlatStripPainter old) =>
      !listEquals(old.stickers, stickers) ||
      !setEquals(old.shown, shown) ||
      !setEquals(old.framed, framed) ||
      !listEquals(old.faceColors, faceColors) ||
      old.unknown != unknown;
}
