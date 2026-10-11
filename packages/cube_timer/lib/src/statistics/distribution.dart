import "dart:math" as math;

import "../database/daos/records.dao.dart";

/// How a set of times spreads out: bars of [step] milliseconds from [start], with whatever lies
/// outside them counted in [below] and [above] rather than stretching the bars to reach it.
typedef Distribution = ({double start, double step, List<int> counts, int below, int above, double median});

/// Steps a bar can be, in milliseconds: widths whose edges read as round numbers.
const _niceSteps = <double>[
  100.0,
  200,
  250,
  500,
  1000,
  2000,
  5000,
  10000,
  15000,
  30000,
  60000,
  120000,
  300000,
  600000,
];

/// Bins the solved [times] into between [minBars] and [maxBars] bars, or null with fewer than
/// [minSolves] solves, where a histogram says nothing.
///
/// The range is Tukey's fences (`Q1 − 1.5·IQR` to `Q3 + 1.5·IQR`, within min and max), so only
/// real outliers — a pop, a +2 — end up in [Distribution.below] / [Distribution.above], and a
/// session without any has none. The width starts from Freedman–Diaconis (`2·IQR·n^−⅓`, finer as
/// solves pile up), is rounded up to a round step so no two bars share a label, and is then moved
/// along those steps until the count of bars fits. Bars start on a multiple of the step.
Distribution? distribute(Iterable<SolveTime> times, {int minBars = 6, int maxBars = 10, int minSolves = 10}) {
  final values = [
    for (final t in times)
      if (!t.isDnf) t.time,
  ]..sort();
  final n = values.length;
  if (n < minSolves) return null;

  final q1 = _quantile(values, 0.25);
  final median = _quantile(values, 0.5);
  final q3 = _quantile(values, 0.75);
  final iqr = q3 - q1;
  final lo = math.max(values.first, q1 - 1.5 * iqr);
  final hi = math.min(values.last, q3 + 1.5 * iqr);

  // One past the bar [hi] falls in, so the slowest time inside the fences is in a bar of its own.
  int bars(double step) => (hi / step).floor() + 1 - (lo / step).floor();

  final raw = iqr > 0 ? 2 * iqr * math.pow(n, -1 / 3) : (hi - lo) / minBars;
  var i = _niceSteps.indexWhere((step) => step >= raw);
  if (i < 0) i = _niceSteps.length - 1;
  while (bars(_niceSteps[i]) > maxBars && i < _niceSteps.length - 1) {
    i++;
  }
  while (bars(_niceSteps[i]) < minBars && i > 0 && bars(_niceSteps[i - 1]) <= maxBars) {
    i--;
  }

  final step = _niceSteps[i];
  final start = (lo / step).floor() * step;
  final counts = List.filled(bars(step), 0);
  final end = start + counts.length * step;
  var below = 0, above = 0;
  for (final v in values) {
    if (v < start) {
      below++;
    } else if (v >= end) {
      above++;
    } else {
      counts[((v - start) / step).floor()]++;
    }
  }

  return (start: start, step: step, counts: counts, below: below, above: above, median: median);
}

/// The [q] quantile of [sorted], interpolated between neighbours.
double _quantile(List<double> sorted, double q) {
  final at = (sorted.length - 1) * q;
  final low = at.floor();
  final high = at.ceil();
  return sorted[low] + (sorted[high] - sorted[low]) * (at - low);
}
