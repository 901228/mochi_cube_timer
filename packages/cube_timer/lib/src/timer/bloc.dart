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
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  /// Cancels the running ticker, if any, and starts a fresh one from zero.
  void _restartTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((elapsed) => add(_TimerTicked(elapsed: elapsed)));
  }

  void _stopTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = null;
  }

  /// Penalty earned by spending [elapsedInspection] ms on inspection.
  Penalty _inspectionPenalty(int elapsedInspection) {
    if (elapsedInspection <= inspectionDuration) return Penalty.none;
    if (elapsedInspection <= inspectionDnfDuration) return Penalty.plus2;
    return Penalty.dnf;
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    // Ignore a second start while inspecting or solving, otherwise it would
    // silently throw away the run in progress.
    if (state is TimerRunInInspection || state is TimerRunInProgress) return;
    emit(const TimerRunInInspection(inspectionDuration));
    _restartTicker();
  }

  void _onInspectionFinished(TimerInspectionFinished event, Emitter<TimerState> emit) {
    if (state is! TimerRunInInspection) return;
    final elapsedInspection = inspectionDuration - state.inspection;
    emit(TimerRunInProgress(0, penalty: _inspectionPenalty(elapsedInspection)));
    // Ends the inspection ticker and starts the solve ticker from zero.
    _restartTicker();
  }

  void _onStopped(TimerStopped event, Emitter<TimerState> emit) {
    if (state is! TimerRunInProgress) return;
    _stopTicker();
    emit(TimerRunComplete(state.elapsed, penalty: state.penalty));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _stopTicker();
    emit(const TimerInitial());
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    if (state is TimerRunInInspection) {
      // The ticker reports the time elapsed since inspection began.
      if (event.elapsed > inspectionDnfDuration) {
        _stopTicker();
        emit(const TimerRunComplete(0, penalty: Penalty.dnf));
      } else {
        emit(TimerRunInInspection(inspectionDuration - event.elapsed));
      }
    } else if (state is TimerRunInProgress) {
      emit(TimerRunInProgress(event.elapsed, penalty: state.penalty));
    }
  }
}
