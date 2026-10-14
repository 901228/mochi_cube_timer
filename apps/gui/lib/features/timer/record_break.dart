import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart";
import "package:mochi_ui/mochi_ui.dart";

/// What a solve broke, in words: how far it went past the old best or worst.
String recordBreakText(RecordBreak record) {
  final seconds = (record.by / 1000).toStringAsFixed(2);
  return switch (record.kind) {
    .best => "New best! −$seconds",
    .worst => "Worst so far +$seconds",
  };
}

/// The best averages a solve set, in words: how far each went past the old best.
String averageBreakText(List<AverageBreak> averages) =>
    "New best ${averages.map((b) => "${b.kind.label} −${(b.by / 1000).toStringAsFixed(2)}").join(" · ")}";

/// One ring that spreads from the middle and fades, each time a new best is announced. Draws
/// nothing the rest of the time, and lets presses through to the timer.
class RecordRipple extends StatefulWidget {
  const RecordRipple({super.key, required this.record});

  final ValueListenable<RecordBreak?> record;

  @override
  State<RecordRipple> createState() => _RecordRippleState();
}

class _RecordRippleState extends State<RecordRipple> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));

  void _onRecord() {
    if (widget.record.value?.kind == .best) _controller.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    widget.record.addListener(_onRecord);
  }

  @override
  void dispose() {
    widget.record.removeListener(_onRecord);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(size: .infinite, painter: _RipplePainter(_controller, context.colors.primary.base)),
  );
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.animation, this.color) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    if (t == 0 || t == 1) return;

    final center = size.center(Offset.zero);
    final radius = Curves.easeOut.transform(t) * size.longestSide * 0.6;
    canvas.drawCircle(center, radius, Paint()..color = color.withValues(alpha: (1 - t) * 0.1));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = .stroke
        ..strokeWidth = 1 + 4 * (1 - t)
        ..color = color.withValues(alpha: (1 - t) * 0.6),
    );
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) => oldDelegate.color != color;
}
