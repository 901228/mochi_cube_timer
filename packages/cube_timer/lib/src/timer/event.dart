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

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});

  /// in milliseconds
  final int duration;
}
