import "package:cube_timer/cube_timer.dart";
import "package:fl_chart/fl_chart.dart";
import "package:mochi_ui/mochi_ui.dart";

typedef StatsReturn = ({SessionSummary summary, List<SolveTime> times});

final FlBorderData borderData = FlBorderData(show: false);
const AxisTitles hideAxisTitles = AxisTitles(sideTitles: SideTitles(showTitles: false));
FlLine horizontalGridLine(BuildContext context) =>
    FlLine(color: context.colors.mutedForeground.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [8]);
