part of "bloc.dart";

/// Where a press is in its lifecycle.
///
/// [waiting] and [armed] gate the start of a solve; [stopping] is the press
/// that ended one, still held down.
enum Hold { none, waiting, armed, stopping }

sealed class TimerState extends Equatable {
  const TimerState({
    required this.elapsed,
    required this.inspection,
    this.penalty = .none,
    this.hold = .none,
  });
  final int inspection;
  final int elapsed;
  final Penalty penalty;
  final Hold hold;

  @override
  List<Object?> get props => [inspection, elapsed, penalty, hold];
}

final class TimerInitial extends TimerState {
  const TimerInitial({super.hold = .none}) : super(elapsed: 0, inspection: 0);

  @override
  String toString() => "TimerInitial { hold: $hold }";
}

final class TimerRunInInspection extends TimerState {
  const TimerRunInInspection(int inspection, {super.hold}) : super(elapsed: 0, inspection: inspection);

  @override
  String toString() => "TimerRunInInspection { rest inspection: $inspection, hold: $hold }";
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int elapsed, {super.penalty = .none}) : super(elapsed: elapsed, inspection: 0);

  @override
  String toString() => "TimerRunInProgress { elapsed: $elapsed }";
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete(
    int elapsed, {
    super.penalty = .none,
    super.hold,
    required this.recordId,
    this.comment = "",
  }) : super(elapsed: elapsed, inspection: 0);

  final String? recordId;
  final String comment;

  @override
  String toString() => "TimerRunComplete { elapsed: $elapsed, hold: $hold }";

  @override
  List<Object?> get props => [...super.props, recordId, comment];
}
