import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:fl_chart/fl_chart.dart";
import "package:mochi_ui/mochi_ui.dart";

import "stats_common.dart";

class TimesDistributionGraph extends StatelessWidget {
  final StatsReturn? data;
  final double aspectRatio;
  final Curve curve;
  final Duration duration;
  const TimesDistributionGraph(
    this.data, {
    super.key,
    this.aspectRatio = 2,
    this.curve = Curves.easeInOutCubic,
    this.duration = const Duration(milliseconds: 1000),
  });

  static const _labelsSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final c = theme.colors;
    final small = theme.typography.body.sm.copyWith(color: c.mutedForeground);
    final d = data == null ? null : distribute(data!.times);

    if (d == null) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: Center(child: Text(data == null ? "" : "Not enough solves yet", style: small)),
      );
    }

    // The bars as drawn: the outliers below, the bars, the outliers above, the ends only when
    // there is something in them.
    final end = d.start + d.counts.length * d.step;
    final decimals = d.step % 1000 == 0 ? 0 : (d.step % 100 == 0 ? 1 : 2);
    String seconds(double ms) => (ms / 1000).toStringAsFixed(decimals);
    final bars = [
      if (d.below > 0) (count: d.below, label: "<${seconds(d.start)}"),
      for (final (i, count) in d.counts.indexed) (count: count, label: "${seconds(d.start + i * d.step)}+"),
      if (d.above > 0) (count: d.above, label: "≥${seconds(end)}"),
    ];
    final m = bars.length;
    final peak = bars.map((b) => b.count).reduce((a, b) => a > b ? a : b);

    final base = [c.success.base, c.primary.base];
    Color colorAt(int i) => m < 2 ? base.first : Color.lerp(base.first, base.last, i / (m - 1))!;

    // Where the median falls, in bars from the left edge: bar i covers [i, i + 1).
    // [+ 0.5]: bar center = label value (16+ center is 16), line falls on the position corresponding to the two labels next to it
    final medianAt = (d.below > 0 ? 1 : 0) + 0.5 + (d.median - d.start) / d.step;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // With no side titles and `spaceAround`, every bar gets an equal slot of the width, so
          // the median's place along the bars is its place along the chart.
          final x = medianAt * constraints.maxWidth / m;

          return Stack(
            children: [
              BarChart(
                BarChartData(
                  alignment: .spaceAround,
                  maxY: peak * 1.3,

                  borderData: borderData,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => horizontalGridLine(context),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: hideAxisTitles,
                    topTitles: hideAxisTitles,
                    leftTitles: hideAxisTitles,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: _labelsSize,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(bars[value.toInt()].label, style: small),
                        ),
                      ),
                    ),
                  ),

                  // The counts sit over the bars as tooltips that are always shown.
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => c.surface.withValues(alpha: 0.0),
                      tooltipPadding: .zero,
                      tooltipMargin: 2,
                      getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                        bars[group.x].count.toString(),
                        small.copyWith(color: colorAt(group.x), fontWeight: .bold),
                      ),
                    ),
                  ),

                  barGroups: bars
                      .mapIndexed(
                        (i, bar) => BarChartGroupData(
                          x: i,
                          showingTooltipIndicators: bar.count > 0 ? [0] : [],
                          barRods: [
                            BarChartRodData(
                              toY: bar.count.toDouble(),
                              color: colorAt(i),
                              width: 12,
                              borderRadius: .circular(12),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),

                duration: duration,
                curve: curve,
              ),

              // The median, as a line through the bars and its value at the top.
              CustomPaint(
                size: constraints.biggest,
                painter: _MedianLine(
                  x: x - 1,
                  y: -10,
                  bottomPadding: _labelsSize,
                  lineColor: c.foreground.withValues(alpha: 0.6),
                  lineWidth: 3,
                  dash: 8,
                  gap: 8,
                  spacing: 2,
                  label: "Median ${(d.median / 1000).toStringAsFixed(2)}",
                  labelStyle: small.copyWith(fontWeight: .bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MedianLine extends CustomPainter {
  final double x, y;

  final Color lineColor;
  final double lineWidth;
  final double dash, gap;
  final double bottomPadding;

  final double spacing;

  final String label;
  final TextStyle? labelStyle;

  _MedianLine({
    required this.x,
    this.y = 0,

    required this.lineColor,
    this.lineWidth = 2,
    this.dash = 4,
    this.gap = 4,
    this.bottomPadding = 0,

    this.spacing = 2,

    required this.label,
    this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // median text label
    final labelPainter = TextPainter(
      textDirection: .ltr,
      text: TextSpan(text: label, style: labelStyle),
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
    );
    labelPainter.layout();

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = .round
      ..strokeJoin = .round;
    for (var yy = labelPainter.height + spacing + y; yy < size.height - bottomPadding; yy += dash + gap) {
      canvas.drawLine(Offset(x, yy), Offset(x, (yy + dash).clamp(0, size.height)), paint);
    }

    labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, y));
  }

  @override
  bool shouldRepaint(_MedianLine old) =>
      old.x != x ||
      old.y != y ||
      old.lineColor != lineColor ||
      old.lineWidth != lineWidth ||
      old.dash != dash ||
      old.gap != gap ||
      old.label != label ||
      old.spacing != spacing ||
      old.bottomPadding != bottomPadding ||
      old.labelStyle != labelStyle;
}
