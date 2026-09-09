import "dart:async";

import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "config.dart";
import "ticker.dart";

part "event.dart";
part "state.dart";

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required this._ticker, required Stream<TimerConfig> config}) : super(const TimerInitial()) {
    _configSubscription = config.listen(
      (config) => _latestConfig = config,
      onError: (Object e, StackTrace s) => addError(e, s),
    );

    on<TimerStarted>(_onStarted);
    on<TimerInspectionFinished>(_onInspectionFinished);
    on<TimerStopped>(_onStopped);
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;

  TimerConfig _latestConfig = const TimerConfig();
  TimerConfig _runConfig =
      const TimerConfig(); // config for current run (guard against config changes during run)

  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<TimerConfig>? _configSubscription;

  int get _inspectionDuration => _runConfig.inspectionDuration.inMilliseconds;
  int get _inspectionDnfThreshold => _runConfig.inspectionDnfThreshold.inMilliseconds;

  @override
  Future<void> close() {
    _configSubscription?.cancel();
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
    if (elapsedInspection <= _inspectionDuration) return Penalty.none;
    if (elapsedInspection <= _inspectionDnfThreshold) return Penalty.plus2;
    return Penalty.dnf;
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    // Ignore a second start while inspecting or solving, otherwise it would
    // silently throw away the run in progress.
    if (state is TimerRunInInspection || state is TimerRunInProgress) return;

    _runConfig = _latestConfig;
    if (_runConfig.inspectionEnabled) {
      emit(TimerRunInInspection(_runConfig.inspectionDuration.inMilliseconds));
    } else {
      emit(TimerRunInProgress(0)); // skip inspection
    }

    _restartTicker();
  }

  void _onInspectionFinished(TimerInspectionFinished event, Emitter<TimerState> emit) {
    if (state is! TimerRunInInspection) return;
    final elapsedInspection = _inspectionDuration - state.inspection;
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
      if (event.elapsed > _inspectionDnfThreshold) {
        _stopTicker();
        emit(const TimerRunComplete(0, penalty: Penalty.dnf));
      } else {
        emit(TimerRunInInspection(_inspectionDuration - event.elapsed));
      }
    } else if (state is TimerRunInProgress) {
      emit(TimerRunInProgress(event.elapsed, penalty: state.penalty));
    }
  }
}
