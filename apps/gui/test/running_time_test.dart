import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/timer/timer_body.dart";

void main() {
  const running = TimerRunInProgress(1234);
  const stopped = TimerRunComplete(1234, recordId: "r");

  test("the time is left out only while the solve runs, and only when the setting says so", () {
    expect(hidesTime(running, showRunningTime: false), isTrue);
    expect(hidesTime(running, showRunningTime: true), isFalse);
  });

  test("once the solve stops, or before it starts, the time shows whatever the setting", () {
    for (final state in [stopped, const TimerInitial(), const TimerRunInInspection(10)]) {
      expect(hidesTime(state, showRunningTime: false), isFalse, reason: "$state");
    }
  });
}
