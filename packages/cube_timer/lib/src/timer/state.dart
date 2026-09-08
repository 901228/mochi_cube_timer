part of "bloc.dart";

enum Penalty { none, plus2, dnf }

sealed class TimerState extends Equatable {
  const TimerState({required this.elapsed, required this.inspection, this.penalty = .none});
  final int inspection;
  final int elapsed;
  final Penalty penalty;

  @override
  List<Object> get props => [inspection, elapsed, penalty];
}

final class TimerInitial extends TimerState {
  const TimerInitial() : super(elapsed: 0, inspection: 0);

  @override
  String toString() => "TimerInitial";
}

final class TimerRunInInspection extends TimerState {
  const TimerRunInInspection(int inspection) : super(elapsed: 0, inspection: inspection);

  @override
  String toString() => "TimerRunInInspection { rest inspection: $inspection }";
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int elapsed, {super.penalty = .none}) : super(elapsed: elapsed, inspection: 0);

  @override
  String toString() => "TimerRunInProgress { elapsed: $elapsed }";
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete(int elapsed, {super.penalty = .none}) : super(elapsed: elapsed, inspection: 0);

  @override
  String toString() => "TimerRunComplete { elapsed: $elapsed }";
}
