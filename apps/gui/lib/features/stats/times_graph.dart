import "dart:ui";

import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:fl_chart/fl_chart.dart";
import "package:mochi_ui/mochi_ui.dart";

import "stats_common.dart";

class TimesGraph extends StatefulWidget {
  final StatsReturn? data;
  final double aspectRatio;
  final Curve curve;
  final Duration duration;
  const TimesGraph(
    this.data, {
    super.key,
    this.aspectRatio = 2,
    this.curve = Curves.easeInOutCubic,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<TimesGraph> createState() => _TimesGraphState();
}

class _TimesGraphState extends State<TimesGraph> with SingleTickerProviderStateMixin {
  late final _reveal = AnimationController(vsync: this, duration: widget.duration);
  var _active = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // the tab that is being closed will not be disposed, only disable TickerMode;
    final active = TickerMode.valuesOf(context).enabled;
    if (active && !_active && widget.data != null) _reveal.forward(from: 0);
    _active = active;
  }

  @override
  void didUpdateWidget(TimesGraph old) {
    super.didUpdateWidget(old);
    // the data may not be ready yet at the first time, wait until it is ready
    if (old.data == null && widget.data != null && _active) _reveal.forward(from: 0);
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    if (widget.data?.times.isEmpty ?? true) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Center(
          child: Text(
            widget.data == null ? "" : "There is no solve yet",
            style: context.theme.typography.body.sm.copyWith(color: c.mutedForeground),
          ),
        ),
      );
    }

    // plot
    final times = widget.data?.times.reversed.toList() ?? <SolveTime>[];
    final spots = [for (final (i, value) in times.indexed) FlSpot(i.toDouble(), value.time / 1000)];
    final ys = spots.map((s) => s.y);
    final lo = ys.isEmpty ? 0.0 : ys.min;
    final hi = ys.isEmpty ? 0.0 : ys.max;
    // if there is only one or all the same, the range is 0, giving it a fixed 1 second
    final yPad = hi > lo ? (hi - lo) * 0.1 : 1.0;

    final base = [c.success.base, c.primary.base];
    final n = spots.length;
    final lineColors = n < 2
        ? base
        : [
            for (final (i, s) in times.indexed)
              s.isDnf ? c.mutedForeground : Color.lerp(base.first, base.last, i / (n - 1))!,
          ];
    // final lineStops = n < 2 ? null : [for (var i = 0; i < n; i++) i / (n - 1)];

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: AnimatedBuilder(
        animation: _reveal,
        builder: (context, _) {
          final head = n < 2
              ? 0.0
              : (widget.curve.transform(_reveal.value) * (n - 1)).clamp(0.0, n - 1.0); // x of the line head
          final i = head.floor();
          final f = head - i;
          final visible = [
            ...spots.take(i + 1),
            if (f > 0) FlSpot(head, lerpDouble(spots[i].y, spots[i + 1].y, f)!),
          ];
          final colors = visible.length < 2
              ? [lineColors.first, lineColors.first]
              : [...lineColors.take(i + 1), if (f > 0) Color.lerp(lineColors[i], lineColors[i + 1], f)!];
          // the stops are the range of the visible points, so we need to recalculate it according to the head
          final stops = visible.length < 2 ? null : [for (final s in visible) s.x / head];

          return LineChart(
            LineChartData(
              minX: 0,
              maxX: n < 2 ? null : (n - 1).toDouble(),
              minY: lo - yPad,
              maxY: hi + yPad * 2,

              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (_) => horizontalGridLine(context),
              ),
              borderData: borderData,
              titlesData: FlTitlesData(
                rightTitles: hideAxisTitles,
                topTitles: hideAxisTitles,
                bottomTitles: hideAxisTitles,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    minIncluded: false,
                    maxIncluded: false,
                    reservedSize: 44,
                    getTitlesWidget: (value, meta) =>
                        SideTitleWidget(meta: meta, child: Text(meta.formattedValue)),
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes
                    .map(
                      (i) => TouchedSpotIndicatorData(
                        FlLine(color: lineColors[i], strokeWidth: 3.5),
                        FlDotData(
                          getDotPainter: (spot, _, bar, _) => FlDotCirclePainter(
                            radius: 5,
                            color: Color(0x00FFFFFF),
                            strokeWidth: 3,
                            strokeColor: lineColors[i],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => c.surface,
                  tooltipBorder: BorderSide(color: c.border),
                  tooltipBorderRadius: .circular(8),
                  fitInsideHorizontally: true,
                  getTooltipItems: (spots) => spots
                      .map(
                        (s) => LineTooltipItem(
                          times[s.x.toInt()].isDnf ? "DNF" : s.y.toStringAsFixed(2),
                          TextStyle(color: lineColors[s.x.toInt()], fontWeight: .bold),
                        ),
                      )
                      .toList(),
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: visible,
                  isCurved: true,
                  gradient: LinearGradient(colors: colors, stops: stops),
                  barWidth: 5,
                  isStrokeCapRound: true,
                  isStrokeJoinRound: true,
                  dotData: FlDotData(
                    checkToShowDot: (spot, _) => times[spot.x.toInt()].isDnf,
                    getDotPainter: (_, _, _, _) => FlDotCrossPainter(color: c.foreground),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: colors.map((color) => color.withValues(alpha: 0.3)).toList(),
                      stops: stops,
                    ),
                  ),
                ),
              ],
            ),
            duration: _reveal.isAnimating ? .zero : widget.duration,
            curve: widget.curve,
          );
        },
      ),
    );
  }
}
