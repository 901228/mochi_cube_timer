part of "bloc.dart";

sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted();
}

final class TimerInspectionFinished extends TimerEvent {
  const TimerInspectionFinished();
}

final class TimerStopped extends TimerEvent {
  const TimerStopped();
}

/// Aborts the current inspection or solve and goes back to [TimerInitial].
final class TimerReset extends TimerEvent {
  const TimerReset();
}

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.elapsed});

  /// milliseconds elapsed since the current ticker started
  final int elapsed;
}
