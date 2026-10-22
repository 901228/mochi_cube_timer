import "package:cube_timer/cube_timer.dart";
import "package:test/test.dart";

void main() {
  SolveTime solved(int ms) => (time: ms.toDouble(), isDnf: false);
  final dnf = (time: 0.0, isDnf: true);

  test("an average leaves out a share of its solves at each end, rounded up to a whole solve", () {
    expect(trimmedCount(5, 5), 1);
    expect(trimmedCount(12, 5), 1);
    expect(trimmedCount(50, 5), 3);
    expect(trimmedCount(100, 5), 5);
    expect(trimmedCount(5, 0), 0);
    expect(trimmedCount(5, 20), 1);
    expect(trimmedCount(12, 20), 3);
  });

  test("so many are never left out that none is left", () {
    expect(trimmedCount(5, 100), 2);
    expect(trimmedCount(3, 100), 1);
  });

  test("the trim sets what an Ao5 drops", () {
    final times = [solved(1000), solved(2000), solved(3000), solved(4000), solved(9000)];
    expect(times.ao(5), 3000); // drops 1000 and 9000
    expect(times.ao(5, trimPercent: 0), 3800); // a plain mean
    expect(times.ao(5, trimPercent: 100), 3000); // only the middle one is left
    expect(times.bestAo(5, trimPercent: 0), 3800);
  });

  test("a DNF that is left after the trim makes the average a DNF", () {
    final times = [solved(1000), solved(2000), solved(3000), dnf, dnf];
    expect(times.ao(5), double.infinity);
    expect(times.ao(5, trimPercent: 100), 3000);
  });
}
