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

    on<TimerPressed>(_onPressed);
    on<TimerReleased>(_onReleased);
    on<TimerReset>(_onReset);
    on<_TimerHoldArmed>(_onHoldArmed);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;

  TimerConfig _latestConfig = const TimerConfig();
  TimerConfig _runConfig =
      const TimerConfig(); // config for current run (guard against config changes during run)

  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<TimerConfig>? _configSubscription;
  Timer? _holdTimer;

  int get _inspectionDuration => _runConfig.inspectionDuration.inMilliseconds;
  int get _inspectionDnfThreshold => _runConfig.inspectionDnfThreshold.inMilliseconds;

  @override
  Future<void> close() {
    _configSubscription?.cancel();
    _tickerSubscription?.cancel();
    _holdTimer?.cancel();
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

  /// Emits [waiting] and arms [_TimerHoldArmed] one hold duration later.
  void _beginHold(Emitter<TimerState> emit, TimerState waiting) {
    emit(waiting);
    _holdTimer?.cancel();
    _holdTimer = Timer(_runConfig.holdDuration, () => add(const _TimerHoldArmed()));
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  /// The current idle state carrying [hold]. A press must not discard the
  /// previous solve, so pressing on [TimerRunComplete] keeps its time on
  /// screen rather than falling back to [TimerInitial].
  TimerState _idleWithHold(Hold hold) => switch (state) {
    TimerRunComplete(:final elapsed, :final penalty) => TimerRunComplete(
      elapsed,
      penalty: penalty,
      hold: hold,
    ),
    _ => TimerInitial(hold: hold),
  };

  /// Penalty earned by spending [elapsedInspection] ms on inspection.
  Penalty _inspectionPenalty(int elapsedInspection) {
    if (elapsedInspection <= _inspectionDuration) return Penalty.none;
    if (elapsedInspection <= _inspectionDnfThreshold) return Penalty.plus2;
    return Penalty.dnf;
  }

  void _onPressed(TimerPressed event, Emitter<TimerState> emit) {
    switch (state) {
      // A solve stops on the press, not on the release, so the recorded time
      // does not depend on how long the finger stays down.
      case TimerRunInProgress():
        _stopTicker();
        emit(TimerRunComplete(state.elapsed, penalty: state.penalty, hold: .stopping));

      // Both paths show the press right away; only what the release does
      // differs. With inspection on the release starts the countdown, so no
      // hold timer runs and the press never arms.
      case TimerInitial() || TimerRunComplete():
        _runConfig = _latestConfig;
        if (_runConfig.inspectionEnabled) {
          emit(_idleWithHold(.waiting));
        } else {
          _beginHold(emit, _idleWithHold(.waiting));
        }

      // Inspection keeps counting down while the press is held.
      case TimerRunInInspection():
        _beginHold(emit, TimerRunInInspection(state.inspection, hold: .waiting));
    }
  }

  void _onHoldArmed(_TimerHoldArmed event, Emitter<TimerState> emit) {
    switch (state) {
      case TimerInitial(hold: .waiting) || TimerRunComplete(hold: .waiting):
        emit(_idleWithHold(.armed));
      case TimerRunInInspection(hold: .waiting):
        emit(TimerRunInInspection(state.inspection, hold: .armed));
      case _:
    }
  }

  void _onReleased(TimerReleased event, Emitter<TimerState> emit) {
    _cancelHold();
    switch (state) {
      case TimerInitial(hold: .armed) || TimerRunComplete(hold: .armed):
        emit(const TimerRunInProgress(0));
        _restartTicker();

      case TimerRunInInspection(hold: .armed):
        final elapsedInspection = _inspectionDuration - state.inspection;
        emit(TimerRunInProgress(0, penalty: _inspectionPenalty(elapsedInspection)));
        // Ends the inspection ticker and starts the solve ticker from zero.
        _restartTicker();

      // A press that never armed. With inspection on that is the whole
      // gesture: the release opens inspection. Otherwise the finger came up
      // before the hold duration, so nothing happens.
      case TimerInitial(hold: .waiting) || TimerRunComplete(hold: .waiting):
        if (_runConfig.inspectionEnabled) {
          emit(TimerRunInInspection(_inspectionDuration));
          _restartTicker();
        } else {
          emit(_idleWithHold(.none));
        }

      // The press that stopped the solve, finally coming up. The run is
      // already complete, so this only clears the hold.
      case TimerRunComplete(hold: .stopping):
        emit(_idleWithHold(.none));

      // Released too early during inspection: drop the hold and leave the
      // countdown carrying on from where it is.
      case TimerRunInInspection(hold: .waiting):
        emit(TimerRunInInspection(state.inspection));

      case _:
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _cancelHold();
    _stopTicker();
    emit(const TimerInitial());
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    if (state is TimerRunInInspection) {
      // The ticker reports the time elapsed since inspection began.
      if (event.elapsed > _inspectionDnfThreshold) {
        _cancelHold();
        _stopTicker();
        emit(const TimerRunComplete(0, penalty: Penalty.dnf));
      } else {
        // Carries the hold through, otherwise every tick would disarm a press
        // the user is still holding.
        emit(TimerRunInInspection(_inspectionDuration - event.elapsed, hold: state.hold));
      }
    } else if (state is TimerRunInProgress) {
      emit(TimerRunInProgress(event.elapsed, penalty: state.penalty));
    }
  }
}
