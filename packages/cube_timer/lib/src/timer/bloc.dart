import "dart:async";

import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../database/daos/records.dao.dart";
import "../puzzle/puzzle.dart";
import "config.dart";
import "ticker.dart";

part "event.dart";
part "state.dart";

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required this._ticker, required Stream<TimerConfig> config, required this._recordsDao})
    : super(const TimerInitial()) {
    _configSubscription = config.listen(
      (config) => _latestConfig = config,
      onError: (Object e, StackTrace s) => addError(e, s),
    );

    on<TimerPressed>(_onPressed);
    on<TimerReleased>(_onReleased);
    on<TimerPressCanceled>(_onPressCanceled);
    on<TimerReset>(_onReset);
    on<TimerStackmatStarted>(_onStackmatStarted);
    on<TimerStackmatStopped>(_onStackmatStopped);
    on<TimerCanceled>(_onTimerCanceled);
    on<_TimerHoldArmed>(_onHoldArmed);
    on<_TimerTicked>(_onTicked);
    on<TimerRecorded>(_onRecorded);
    on<TimerDeleteRecord>(_onDeleteRecord);
    on<TimerChangePenalty>(_onChangePenalty);
    on<TimerChangeComment>(_onChangeComment);
  }

  final Ticker _ticker;
  final RecordsDao _recordsDao;

  TimerConfig _latestConfig = const TimerConfig();
  TimerConfig _runConfig =
      const TimerConfig(); // config for current run (guard against config changes during run)
  TimerConfig get runConfig => _runConfig;

  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<TimerConfig>? _configSubscription;
  Timer? _holdTimer;

  /// Whether the solve running was started by a Stackmat. Whoever starts a solve ends it: a touch
  /// that began one is not undone by the Stackmat's idle packets, and a touch cannot end one the
  /// Stackmat is timing, so a hand brushing the screen does not stop it.
  bool _stackmatRun = false;

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
    TimerRunComplete(:final elapsed, :final penalty, :final recordId, :final comment) => TimerRunComplete(
      elapsed,
      penalty: penalty,
      hold: hold,
      recordId: recordId,
      comment: comment,
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
        if (_stackmatRun) return;
        _stopTicker();
        emit(TimerRunComplete(state.elapsed, penalty: state.penalty, hold: .stopping, recordId: null));

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
        _stackmatRun = false;
        emit(const TimerRunInProgress(0));
        _restartTicker();

      case TimerRunInInspection(hold: .armed):
        _stackmatRun = false;
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

  /// Unlike a release, a cancelled press must not act on the hold it was
  /// building: it only drops the hold, so an inspection carries on counting
  /// down and a completed solve keeps its time on screen.
  void _onPressCanceled(TimerPressCanceled event, Emitter<TimerState> emit) {
    _cancelHold();
    switch (state) {
      case TimerInitial() || TimerRunComplete():
        emit(_idleWithHold(.none));

      case TimerRunInInspection():
        emit(TimerRunInInspection(state.inspection));

      // A solve in progress tracks no hold, so there is nothing to drop.
      case TimerRunInProgress():
    }
  }

  void _onStackmatStarted(TimerStackmatStarted event, Emitter<TimerState> emit) {
    _cancelHold();
    switch (state) {
      case TimerInitial() || TimerRunComplete():
        _runConfig = _latestConfig;
        _stackmatRun = true;
        emit(const TimerRunInProgress(0));
        _restartTicker();

      case TimerRunInInspection():
        _stackmatRun = true;
        emit(TimerRunInProgress(0, penalty: _inspectionPenalty(_inspectionDuration - state.inspection)));
        _restartTicker();

      // Already running, from the screen or from an earlier packet: nothing to start.
      case TimerRunInProgress():
    }
  }

  void _onStackmatStopped(TimerStackmatStopped event, Emitter<TimerState> emit) {
    if (state is! TimerRunInProgress || !_stackmatRun) return;
    _stackmatRun = false;
    _stopTicker();
    emit(TimerRunComplete(event.elapsed, penalty: state.penalty, recordId: null));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _stackmatRun = false;
    _cancelHold();
    _stopTicker();
    emit(const TimerInitial());
  }

  void _onTimerCanceled(TimerCanceled event, Emitter<TimerState> emit) {
    _stackmatRun = false;
    _cancelHold();
    _stopTicker();
    if (state is TimerRunInProgress) {
      emit(TimerRunComplete(state.elapsed, penalty: Penalty.dnf, recordId: null));
    } else {
      emit(const TimerInitial());
    }
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    if (state is TimerRunInInspection) {
      // The ticker reports the time elapsed since inspection began.
      if (event.elapsed > _inspectionDnfThreshold) {
        _cancelHold();
        _stopTicker();
        emit(const TimerRunComplete(0, penalty: Penalty.dnf, recordId: null));
      } else {
        // Carries the hold through, otherwise every tick would disarm a press
        // the user is still holding.
        emit(TimerRunInInspection(_inspectionDuration - event.elapsed, hold: state.hold));
      }
    } else if (state is TimerRunInProgress) {
      emit(TimerRunInProgress(event.elapsed, penalty: state.penalty));
    }
  }

  Future<void> _onRecorded(TimerRecorded event, Emitter<TimerState> emit) async {
    if (state case TimerRunComplete(recordId: null)) {
      final id = await _recordsDao.add(
        puzzle: event.puzzle,
        session: event.sessionId,
        scramble: event.notation,
        time: state.elapsed,
        penalty: state.penalty,
      );

      // The reset that happened while the insert was in flight wins: emitting
      // here would put a run the user abandoned back on screen.
      if (state case TimerRunComplete(:final elapsed, :final penalty, :final hold, :final comment)) {
        emit(TimerRunComplete(elapsed, penalty: penalty, hold: hold, recordId: id, comment: comment));
      }
    }
  }

  String? get _recordId => switch (state) {
    TimerRunComplete(:final recordId) => recordId,
    _ => null,
  };

  Future<void> _onDeleteRecord(TimerDeleteRecord event, Emitter<TimerState> emit) async {
    if (_recordId case final id?) {
      await _recordsDao.softDelete(id);
      add(const TimerReset());
    }
  }

  Future<void> _onChangePenalty(TimerChangePenalty event, Emitter<TimerState> emit) async {
    if (_recordId case final id?) {
      await _recordsDao.setPenalty(id, event.penalty);
      emit(
        TimerRunComplete(
          state.elapsed,
          penalty: event.penalty,
          hold: state.hold,
          recordId: id,
          comment: (state as TimerRunComplete).comment,
        ),
      );
    }
  }

  Future<void> _onChangeComment(TimerChangeComment event, Emitter<TimerState> emit) async {
    if (state case TimerRunComplete(:final recordId?, :final comment)) {
      if (comment == event.comment) return;

      await _recordsDao.setComment(recordId, event.comment);
      emit(
        TimerRunComplete(
          state.elapsed,
          penalty: state.penalty,
          hold: state.hold,
          recordId: recordId,
          comment: event.comment,
        ),
      );
    }
  }
}
