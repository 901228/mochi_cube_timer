import "package:cube_timer/cube_timer.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/timer/timer_focus.dart";

void main() {
  test("the screen stays awake through inspection and the solve, and is released after", () async {
    final awake = <bool>[];
    final cubit = TimerFocusCubit(keepAwake: awake.add);

    cubit.follow(const TimerRunInInspection(15));
    cubit.follow(const TimerRunInProgress(0));
    cubit.follow(const TimerInitial());

    expect(awake, [true, false]);
    await cubit.close();
  });

  test("closing mid-solve releases the screen", () async {
    final awake = <bool>[];
    final cubit = TimerFocusCubit(keepAwake: awake.add)..follow(const TimerRunInProgress(0));

    await cubit.close();

    expect(awake, [true, false]);
  });
}
