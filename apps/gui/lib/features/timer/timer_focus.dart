import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:wakelock_plus/wakelock_plus.dart";

/// Whether a solve is running, so the shell around the timer can step aside.
///
/// While it is, the screen is kept awake: inspection and a long solve both outlast the time a phone
/// takes to dim, and the timer cannot be touched to wake it.
class TimerFocusCubit extends Cubit<bool> {
  TimerFocusCubit({this.keepAwake = _wakelock}) : super(false);

  final void Function(bool awake) keepAwake;

  static void _wakelock(bool awake) => WakelockPlus.toggle(enable: awake);

  void follow(TimerState state) => emit(state is TimerRunInInspection || state is TimerRunInProgress);

  @override
  void onChange(Change<bool> change) {
    super.onChange(change);
    keepAwake(change.nextState);
  }

  @override
  Future<void> close() {
    // Leaving mid-solve must not leave the screen locked on.
    if (state) keepAwake(false);
    return super.close();
  }
}
