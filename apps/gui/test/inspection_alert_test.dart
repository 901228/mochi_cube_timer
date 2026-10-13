import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/timer/alert.dart";

void main() {
  const duration = Duration(seconds: 15);
  // Alerts at 8s and 12s elapsed, so 7s and 3s left.
  TimerState left(double seconds) => TimerRunInInspection((seconds * 1000).round());

  test("each alert stage is reached once, as inspection passes 8s and 12s", () {
    final states = [left(15), left(7.5), left(7.2), left(7), left(6.9), left(3.1), left(3), left(2.4)];
    final stages = [for (final s in states) inspectionAlertStage(s, duration)];
    expect(stages, [0, 0, 0, 1, 1, 1, 2, 2]);

    // The listener fires where the stage goes up: once per alert, however often the state repeats.
    var fired = 0;
    for (var i = 1; i < stages.length; i++) {
      if (stages[i] > stages[i - 1]) fired++;
    }
    expect(fired, 2);
  });

  test("a state that is not inspection is past no alert", () {
    expect(inspectionAlertStage(const TimerInitial(), duration), 0);
    expect(inspectionAlertStage(const TimerRunInProgress(9000), duration), 0);
  });
}
