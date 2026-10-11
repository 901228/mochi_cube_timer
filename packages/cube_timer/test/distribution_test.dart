import "dart:math" as math;

import "package:cube_timer/cube_timer.dart";
import "package:test/test.dart";

List<SolveTime> solves(Iterable<double> seconds) => [for (final s in seconds) (time: s * 1000, isDnf: false)];

/// A session of [n] times spread roughly normally around [mean] seconds, the same every run.
List<SolveTime> session(int n, {double mean = 17.4, double sd = 1.8}) {
  final random = math.Random(1);
  return solves([
    for (var i = 0; i < n; i++)
      mean +
          sd *
              math.sqrt(-2 * math.log(1 - random.nextDouble())) *
              math.cos(2 * math.pi * random.nextDouble()),
  ]);
}

int total(Distribution d) => d.counts.fold(d.below + d.above, (a, b) => a + b);

void main() {
  test("too few solves draw nothing", () {
    expect(distribute(solves([10, 11, 12])), isNull);
    // DNFs do not count towards the solves either.
    expect(distribute([...solves(List.filled(9, 12)), (time: 0, isDnf: true)]), isNull);
  });

  test("every solve is counted once, and DNFs not at all", () {
    final times = [...session(158), (time: 0.0, isDnf: true)];
    final d = distribute(times)!;
    expect(total(d), 158);
  });

  test("the bars are a round width starting on a multiple of it, between 6 and 10 of them", () {
    for (final n in [12, 50, 158, 1000, 5000]) {
      final d = distribute(session(n))!;
      expect(d.counts.length, inInclusiveRange(6, 10), reason: "$n solves");
      expect(d.start % d.step, 0, reason: "$n solves");
      // A step of a tenth of a second or more: no two bars can share a label.
      expect(d.step, greaterThanOrEqualTo(100));
    }
  });

  test("a session without outliers has nothing past either end", () {
    final d = distribute(solves([for (var i = 0; i < 40; i++) 15 + i * 0.1]))!;
    expect(d.below, 0);
    expect(d.above, 0);
  });

  test("a pop lands past the end instead of stretching the bars to reach it", () {
    final d = distribute([
      ...session(100),
      ...solves([45]),
    ])!;
    expect(d.above, greaterThanOrEqualTo(1));
    expect(d.start + d.counts.length * d.step, lessThan(45000));
  });

  test("the median is the middle solve", () {
    final d = distribute(solves([for (var i = 1; i <= 11; i++) i.toDouble()]))!;
    expect(d.median, 6000);
  });

  test("a session of identical times is one bar, not a crash", () {
    final d = distribute(solves(List.filled(12, 15)))!;
    expect(total(d), 12);
    expect(d.counts.where((c) => c > 0), [12]);
  });
}
