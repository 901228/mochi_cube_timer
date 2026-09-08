import "dart:async";

import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "ticker.dart";

part "event.dart";
part "state.dart";

// TODO: make [inspectDuration] and [inspectDnfDuration] configurable

/// default inspection duration in milliseconds
const int inspectionDuration = 15 * 1000;

/// default inspection duration which caused dnf in milliseconds
const int inspectionDnfDuration = 17 * 1000;

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker}) : _ticker = ticker, super(const TimerInitial()) {
    on<TimerStarted>(_onStarted);
    on<TimerInspectionFinished>(_onInspectionFinished);
    on<TimerStopped>(_onStopped);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInInspection(inspectionDuration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onInspectionFinished(TimerInspectionFinished event, Emitter<TimerState> emit) {
    if (state is TimerRunInInspection) {
      final elapsedInspection = inspectionDuration - state.inspection;
      _tickerSubscription?.cancel();
      emit(
        TimerRunInProgress(
          0,
          penalty: elapsedInspection <= inspectionDuration
              ? Penalty.none
              : elapsedInspection <= inspectionDnfDuration
              ? Penalty.plus2
              : Penalty.dnf,
        ),
      );
      _tickerSubscription = _ticker.tick().listen((duration) => add(_TimerTicked(duration: duration)));
    }
  }

  void _onStopped(TimerStopped resume, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.cancel();
      emit(TimerRunComplete(state.elapsed, penalty: state.penalty));
    }
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    if (state is TimerRunInInspection) {
      final elapsedInspection = inspectionDuration - state.inspection;
      if (elapsedInspection <= inspectionDnfDuration) {
        emit(TimerRunInInspection(state.inspection - event.duration));
      } else {
        emit(TimerRunComplete(0, penalty: Penalty.dnf));
      }
    } else if (state is TimerRunInProgress) {
      emit(TimerRunInProgress(state.elapsed + event.duration, penalty: state.penalty));
    }
  }
}
