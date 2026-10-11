part of "bloc.dart";

sealed class TimerEvent {
  const TimerEvent();
}

final class TimerPressed extends TimerEvent {
  const TimerPressed();
}

final class TimerReleased extends TimerEvent {
  const TimerReleased();
}

/// A press that went away without a release, e.g. the pointer was lost to a
/// scroll or another gesture won the arena.
final class TimerPressCanceled extends TimerEvent {
  const TimerPressCanceled();
}

/// Aborts the current inspection or solve and goes back to [TimerInitial].
final class TimerReset extends TimerEvent {
  const TimerReset();
}

final class TimerCanceled extends TimerEvent {
  const TimerCanceled();
}

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.elapsed});

  /// milliseconds elapsed since the current ticker started
  final int elapsed;
}

/// Fired by the hold timer once a press has been held for
/// [TimerConfig.holdDuration], arming the release that starts the solve.
class _TimerHoldArmed extends TimerEvent {
  const _TimerHoldArmed();
}

class TimerRecorded extends TimerEvent {
  const TimerRecorded({required this.sessionId, required this.puzzle, required this.notation});

  final String sessionId;
  final Puzzle puzzle;
  final String notation;
}

class TimerDeleteRecord extends TimerEvent {
  const TimerDeleteRecord();
}

class TimerChangePenalty extends TimerEvent {
  const TimerChangePenalty(this.penalty);

  final Penalty penalty;
}

class TimerChangeComment extends TimerEvent {
  const TimerChangeComment(this.comment);

  final String comment;
}
