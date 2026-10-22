import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/shared/utils.dart";

void main() {
  Duration ms(int n) => Duration(milliseconds: n);

  test("a time is cut off, not rounded, to the decimals shown", () {
    expect(ms(1497).timerString(decimals: 1), "1.4");
    expect(ms(1497).timerString(), "1.49");
    expect(ms(1497).timerString(decimals: 3), "1.497");
  });

  test("a time just under the next second does not grow a digit", () {
    expect(ms(1996).timerString(), "1.99");
    expect(ms(1999).timerString(decimals: 1), "1.9");
  });

  test("minutes and hours are laid out as before", () {
    expect(ms(61500).timerString(), "1:01.50");
    expect(ms(600000).timerString(decimals: 3), "10:00.000");
    expect(ms(3723400).timerString(), "1:02:03.40");
  });

  test("a penalty shows with the same decimals", () {
    expect(ms(1497).timerDisplayString(Penalty.plus2, decimals: 3), "3.497");
    expect(ms(1497).timerDisplayString(Penalty.dnf), "DNF");
  });
}
