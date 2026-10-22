import "../stackmat.dart";
import "bloc.dart";

extension StackmatEvents on Stream<StackmatState> {
  /// What the timer's packets mean to the solve: it starting when the time begins to run, and
  /// stopping, at the time it shows, when the time stops.
  ///
  /// Only the changes count; every packet repeats the state, many times a second.
  Stream<TimerEvent> get timerEvents async* {
    var running = false;
    await for (final state in this) {
      if (state.running == running) continue;
      running = state.running;
      yield running ? const TimerStackmatStarted() : TimerStackmatStopped(state.elapsed.inMilliseconds);
    }
  }
}
